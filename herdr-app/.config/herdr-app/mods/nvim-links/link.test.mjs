// Run: node --experimental-vm-modules --test herdr-app/.config/herdr-app/mods/nvim-links/link.test.mjs
import assert from "node:assert/strict";
import { mkdtemp, readFile, realpath, rm, writeFile } from "node:fs/promises";
import { spawn, spawnSync } from "node:child_process";
import { once } from "node:events";
import test from "node:test";
import { SourceTextModule, SyntheticModule } from "node:vm";

async function handler({ editors = [], result = { code: 0 }, execute } = {}) {
  const calls = [];
  const api = {
    spaces: () => [{ id: "project", folder: "/repo", tabs: [{ id: "code" }, { id: "agent" }] }],
    panes: () => editors.map(e => ({ tab: "code", program: { key: "nvim" }, ...e })),
    terminals: () => editors.map(e => ({ address: e.terminal, state: "live", labels: { "nvim.server": `/tmp/${e.terminal}.sock` }, ...e })),
    exec: async (...args) => { calls.push(["exec", ...args]); return execute ? execute(...args) : result; },
    run: (...args) => calls.push(["run", ...args]),
  };
  const host = new SyntheticModule(Object.keys(api), function () {
    for (const [key, value] of Object.entries(api)) this.setExport(key, value);
  });
  const mod = new SourceTextModule(await readFile(new URL("./link.js", import.meta.url), "utf8"));
  await mod.link(() => host);
  await mod.evaluate();
  return { click: mod.namespace.handleLink, calls };
}

const click = {
  link: { kind: "file", raw: "src/file.rs:42:7", path: "/repo/src/file.rs" },
  source: { terminal: "agent", machine: null, cwd: "/repo", space: "project", tab: "agent" },
};

test("opens a Neovim tab in the clicked space when there is no editor", async () => {
  const h = await handler();
  assert.equal(await h.click(click), "handled");
  assert.deepEqual(JSON.parse(JSON.stringify(h.calls)), [["run", "tab.new", {
    space: "project", folder: "/repo", argv: ["nvim", "+call cursor(42,7)", "--", "/repo/src/file.rs"],
  }]]);
});

test("reuses an editor in this space, preferring the clicked tab", async () => {
  const h = await handler({ editors: [
    { terminal: null, tab: "code", mod: "files", program: null },
    { terminal: "unrelated", tab: "other-project" },
    { terminal: "code-editor" },
    { terminal: "same-tab", tab: "agent" },
  ] });
  assert.equal(await h.click(click), "handled");
  assert.equal(h.calls[0][0], "exec");
  assert.deepEqual(Array.from(h.calls[0][2]).slice(0, 3), ["--server", "/tmp/same-tab.sock", "--remote-expr"]);
  assert.deepEqual(JSON.parse(JSON.stringify(h.calls.slice(1))), [
    ["run", "space.select", { id: "project" }],
    ["run", "tab.select", { id: "agent" }],
    ["run", "pane.focus", { terminal: "same-tab" }],
  ]);
});

test("leaves URLs, unresolved paths and remote terminals to other handlers", async () => {
  const h = await handler();
  for (const c of [
    { ...click, link: { kind: "url", raw: "https://example.com", url: "https://example.com" } },
    { ...click, link: { ...click.link, path: null } },
    { ...click, source: { ...click.source, machine: "remote" } },
  ]) assert.equal(await h.click(c), "pass");
  assert.equal(h.calls.length, 0);
});

test("does not open a duplicate or change focus when RPC fails", async () => {
  const h = await handler({ editors: [{ terminal: "editor" }], result: { code: 1, stderr: "socket unavailable" } });
  await assert.rejects(h.click(click), /socket unavailable/);
  assert.equal(h.calls.length, 1);
});

test("asks to reload an existing editor without socket registration", async () => {
  const h = await handler({ editors: [{ terminal: "editor", labels: {} }] });
  await assert.rejects(h.click(click), /restart|reload/i);
  assert.equal(h.calls.length, 0);
});

test("real Neovim RPC opens quoted filenames at the cursor and preserves unsaved text", { timeout: 10000 }, async () => {
  const dir = await mkdtemp("/tmp/nvim-links-");
  const socket = `${dir}/rpc.sock`;
  const path = `${dir}/quote' | let g:injected=1 | \".rs`;
  await writeFile(path, "some source code\n".repeat(60));
  const server = spawn("nvim", ["--headless", "--clean", "--listen", socket,
    "+lua io.stdout:write('ready\\n'); io.stdout:flush()"]);
  const rpc = expression => {
    const r = spawnSync("nvim", ["--server", socket, "--remote-expr", expression], { encoding: "utf8", timeout: 3000 });
    assert.equal(r.status, 0, r.stderr);
    return r.stdout.trim();
  };
  try {
    await once(server.stdout, "data");
    rpc(`luaeval('(function() vim.o.hidden=false; vim.api.nvim_buf_set_lines(0,0,-1,false,{"unsaved work"}); return true end)()')`);
    const h = await handler({ editors: [{ terminal: "editor" }], execute: (command, args) => {
      const r = spawnSync(command, ["--server", socket, ...args.slice(2)], { encoding: "utf8", timeout: 3000 });
      return { code: r.status, stdout: r.stdout, stderr: r.stderr };
    } });
    assert.equal(await h.click({ ...click, link: { kind: "file", path, raw: `${path}:42:7` } }), "handled");
    const state = JSON.parse(rpc(`json_encode(luaeval('{vim.api.nvim_buf_get_name(0), vim.fn.line("."), vim.fn.col("."), vim.api.nvim_buf_get_lines(1,0,-1,false), vim.bo[1].modified, vim.g.injected or false}'))`));
    assert.deepEqual(state, [await realpath(path), 42, 7, ["unsaved work"], true, false]);
  } finally {
    server.kill();
    await once(server, "exit");
    await rm(dir, { recursive: true, force: true });
  }
});

import { exec, panes, run, spaces, terminals } from "herdr";

export async function handleLink({ link, source }) {
  // shortcut: local resolved paths only; add remote path resolution when needed.
  if (link.kind !== "file" || !link.path || source.machine) return "pass";
  const space = spaces().find(s => s.id === source.space);
  if (!space) return "pass";

  const suffix = link.raw.match(/:(\d+)(?::(\d+))?:?$/);
  const line = Math.max(1, Number(suffix?.[1] || 1));
  const column = Math.max(1, Number(suffix?.[2] || 1));
  if (!Number.isSafeInteger(line) || !Number.isSafeInteger(column)) return "pass";

  const editors = panes().filter(p => p.program?.key === "nvim" && space.tabs.some(t => t.id === p.tab));
  const editor = editors.find(p => p.tab === source.tab) || editors[0];
  if (!editor) {
    run("tab.new", {
      space: space.id,
      folder: source.cwd || space.folder,
      argv: ["nvim", `+call cursor(${line},${column})`, "--", link.path],
    });
    return "handled";
  }

  const socket = terminals().find(t => t.address === editor.terminal && t.state === "live")?.labels?.["nvim.server"];
  if (!socket) throw new Error("Restart Neovim once, or reload minvim.herdr, to enable file clicks.");

  // JSON is data, never Ex/Lua source. :hide keeps any modified buffer loaded.
  const args = JSON.stringify([link.path, line, column]).replace(/'/g, "''");
  const lua = '(function() vim.cmd.edit({args={_A[1]},mods={hide=true}}); vim.fn.cursor(_A[2],_A[3]); vim.cmd("normal! zvzz"); return true end)()';
  const expression = `luaeval('${lua}', json_decode('${args}'))`;
  const result = await exec("nvim", ["--server", socket, "--remote-expr", expression]);
  if (result.code !== 0) throw new Error(result.stderr || "Could not open the file in Neovim");

  run("space.select", { id: space.id });
  run("tab.select", { id: editor.tab });
  run("pane.focus", { terminal: editor.terminal });
  return "handled";
}

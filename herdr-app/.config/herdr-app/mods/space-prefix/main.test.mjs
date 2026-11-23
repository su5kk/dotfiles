// Run: node --experimental-vm-modules --test herdr-app/.config/herdr-app/mods/space-prefix/main.test.mjs
import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";
import { SourceTextModule, SyntheticModule } from "node:vm";

const keys = JSON.parse(await readFile(new URL("../../keys.json", import.meta.url), "utf8"));

test("prefix then b delivers the sidebar command", () => {
  assert.equal(keys.global["`"], "mod.open:space-prefix");
  assert.equal(keys["mod:space-prefix"].b, "space-prefix.sidebar");
});

test("the sidebar command toggles visibility and closes the prefix popup", async () => {
  const calls = [];
  const api = {
    checking: () => false,
    closeOverlay: id => calls.push(["close", id]),
    focused: () => null,
    hc: () => { throw new Error("Sidebar toggles must not send terminal input"); },
    nextCommand: () => {},
    props: () => ({ overlay: "prefix-popup" }),
    run: (command, args) => calls.push([command, args.id]),
    theme: () => ({}),
  };
  const host = new SyntheticModule(Object.keys(api), function () {
    for (const [name, value] of Object.entries(api)) this.setExport(name, value);
  });
  const ui = new SyntheticModule(["View", "div"], function () {
    this.setExport("View", class {});
    this.setExport("div", () => {});
  });
  const mod = new SourceTextModule(await readFile(new URL("./main.js", import.meta.url), "utf8"));
  await mod.link(name => name === "herdr" ? host : ui);
  await mod.evaluate();
  await new mod.namespace.default().choose("sidebar");
  assert.deepEqual(calls, [["layout.toggle", "sidebar"], ["close", "prefix-popup"]]);
});

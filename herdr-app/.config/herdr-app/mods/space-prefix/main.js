import { View, div } from "gpui-kit";
import { checking, closeOverlay, focused, hc, nextCommand, props, run, theme } from "herdr";

export default class SpacePrefix extends View {
  init(_props, cx) {
    this.terminal = focused()?.terminal;
    this.handle = cx.focus_handle();
    this.handle.focus();
    if (checking()) return;
    cx.spawn(async () => this.choose(await nextCommand()));
  }

  async choose(command) {
    if (/^[1-9]$/.test(command)) {
      closeOverlay(props().overlay);
      run("space.select", { index: Number(command) });
      return;
    } else if (command === "literal") {
      if (this.terminal) {
        const result = await hc(["keys", this.terminal, "`"]);
        if (result.code !== 0) throw new Error(result.stderr || "Could not type a backtick");
      }
    } else {
      return;
    }
    closeOverlay(props().overlay);
  }

  render() {
    const t = theme();
    return div().id("space-prefix").track_focus(this.handle)
      .size_full().p(16).bg(t.popover).text_color(t.foreground).text_size(13)
      .child("1-9: space    `: type backtick    Esc: cancel");
  }
}

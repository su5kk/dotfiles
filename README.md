# Dotfiles

Personal macOS development environment configuration files managed with GNU Stow.

## Installation

### Install GNU Stow

```bash
# macOS
brew install stow
```

### Install Configurations

```bash
# Navigate to dotfiles directory
cd ~/dotfiles

# Install all configurations
# --no-folding keeps runtime files out of stateful config directories
stow --no-folding --ignore=nvim-links --target="$HOME" */
ln -s "$PWD/herdr-app/.config/herdr-app/mods/nvim-links" "$HOME/.config/herdr-app/mods/nvim-links"

# Or install specific applications
stow --no-folding --target="$HOME" nvim
stow --no-folding --target="$HOME" zed
stow --no-folding --target="$HOME" fish
stow --no-folding --target="$HOME" wezterm
stow --no-folding --target="$HOME" tmux
stow --no-folding --target="$HOME" aerospace
stow --no-folding --target="$HOME" pi
stow --no-folding --target="$HOME" agents
stow --no-folding --target="$HOME" herdr
stow --no-folding --ignore=nvim-links --target="$HOME" herdr-app
ln -s "$PWD/herdr-app/.config/herdr-app/mods/nvim-links" "$HOME/.config/herdr-app/mods/nvim-links"
```

If a destination file already exists, back it up or remove it before running Stow.
Fish state and private functions are not managed here.
Zed backups, temporary files, conversations, embeddings, and prompt databases remain local.
Pi credentials and session data, plus Herdr sessions, logs, and sockets, remain local.
Herdr desktop settings, keys, layouts and their state, themes, mods, UI assets, and shared preferences are preserved.
Desktop history, mod runtime data, telemetry, backups, and update caches remain local.
Review future `shared.json` changes before committing; mods can store arbitrary data there.
The Context7 MCP entry reads `pi-context7-api-key` from the current user's macOS Keychain.

### Herdr file clicks

In the Rose Pine layout, Cmd-click a detected local path such as `./src/file.rs:42:7` to open it in Neovim in the same space. The current tab's editor wins; otherwise the first editor in that space is used. If none exists, a Neovim tab opens. URLs and remote paths keep their normal behavior.

Neovim registers its RPC socket with Herdr on startup. For an editor that was already open when this config changed, run `:lua require("minvim.herdr")` once. Modified buffers stay loaded when a click opens another file.

Keep `mods/nvim-links` linked as a whole directory. Herdr rejects a `link.js` symlink pointing outside its mod directory. Use `--ignore=nvim-links` when restowing Herdr so Stow leaves that directory link intact.

### Useful Commands

```bash
# Reinstall (useful after updates)
stow --no-folding --target="$HOME" -R nvim

# Remove configuration
stow --target="$HOME" -D nvim

# Dry run to see what would happen
stow --no-folding --target="$HOME" -n nvim
```

## Applications Configured

- **Neovim** (`nvim/`) - Text editor with Lazy.nvim plugin manager
- **Zed** (`zed/`) - Editor settings, keymap, and custom Rosé Pine theme
- **Fish Shell** (`fish/`) - Shell with Fisher plugin manager and Pure prompt
- **WezTerm** (`wezterm/`) - Terminal emulator
- **Tmux** (`tmux/`) - Terminal multiplexer with TPM plugin manager
- **AeroSpace** (`aerospace/`) - Tiling window manager
- **Pi** (`pi/`) - Agent harness settings and extensions
- **Agents** (`agents/`) - Global agent skills (`~/.agents`)
- **Herdr** (`herdr/`) - Agent workspace configuration
- **Herdr desktop** (`herdr-app/`) - Desktop settings, keybindings, layouts, themes, and mods

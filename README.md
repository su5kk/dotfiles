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
stow --no-folding --target="$HOME" */

# Or install specific applications
stow --no-folding --target="$HOME" nvim
stow --no-folding --target="$HOME" fish
stow --no-folding --target="$HOME" wezterm
stow --no-folding --target="$HOME" tmux
stow --no-folding --target="$HOME" aerospace
stow --no-folding --target="$HOME" pi
stow --no-folding --target="$HOME" herdr
```

If a destination file already exists, back it up or remove it before running Stow.
Fish state and private functions are not managed here.
Pi credentials and session data, plus Herdr sessions, logs, and sockets, remain local.
The Context7 MCP entry reads `pi-context7-api-key` from the current user's macOS Keychain.

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
- **Fish Shell** (`fish/`) - Shell with Fisher plugin manager and Starship prompt
- **WezTerm** (`wezterm/`) - Terminal emulator
- **Tmux** (`tmux/`) - Terminal multiplexer with TPM plugin manager
- **AeroSpace** (`aerospace/`) - Tiling window manager
- **Pi** (`pi/`) - Agent harness settings and extensions
- **Herdr** (`herdr/`) - Agent workspace configuration

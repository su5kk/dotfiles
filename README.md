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
stow */

# Or install specific applications
stow nvim
stow fish
stow wezterm
stow tmux
stow zed
stow aerospace
```

### Useful Commands

```bash
# Reinstall (useful after updates)
stow -R nvim

# Remove configuration
stow -D nvim

# Dry run to see what would happen
stow -n nvim
```

## Applications Configured

- **Neovim** (`nvim/`) - Text editor with Lazy.nvim plugin manager
- **Fish Shell** (`fish/`) - Shell with Fisher plugin manager and Starship prompt
- **WezTerm** (`wezterm/`) - Terminal emulator
- **Zed Editor** (`zed/`) - Modern text editor with Vim mode
- **Tmux** (`tmux/`) - Terminal multiplexer with TPM plugin manager
- **AeroSpace** (`aerospace/`) - Tiling window manager

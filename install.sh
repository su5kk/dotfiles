#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if brew cask exists
cask_exists() {
    brew list --cask "$1" >/dev/null 2>&1
}

# Function to check if brew formula exists
formula_exists() {
    brew list "$1" >/dev/null 2>&1
}

print_status "Starting installation of development tools..."

# Install Homebrew if not present
if ! command_exists brew; then
    print_status "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for current session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    print_status "Homebrew is already installed"
    print_status "Updating Homebrew..."
    brew update
fi

# Install Fish shell
if ! formula_exists fish; then
    print_status "Installing Fish shell..."
    brew install fish
else
    print_status "Fish shell is already installed"
fi

FISH_PATH="$(command -v fish)"
if [[ -n "$FISH_PATH" ]]; then
    if ! grep -qx "$FISH_PATH" /etc/shells; then
        print_status "Adding Fish to /etc/shells..."
        echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
    fi

    CURRENT_SHELL="$(dscl . -read "$HOME" UserShell 2>/dev/null | awk '{print $2}')"
    if [[ "$CURRENT_SHELL" != "$FISH_PATH" ]]; then
        print_status "Setting Fish as the default login shell..."
        chsh -s "$FISH_PATH"
    fi
fi

# Install Neovim
if ! formula_exists neovim; then
    print_status "Installing Neovim..."
    brew install neovim
else
    print_status "Neovim is already installed"
fi

# Install Tmux
if ! formula_exists tmux; then
    print_status "Installing Tmux..."
    brew install tmux
else
    print_status "Tmux is already installed"
fi

# Install WezTerm
if ! cask_exists wezterm; then
    print_status "Installing WezTerm..."
    brew install --cask wezterm
else
    print_status "WezTerm is already installed"
fi

# Install AeroSpace
if ! cask_exists aerospace; then
    print_status "Installing AeroSpace window manager..."
    brew install --cask nikitabobko/tap/aerospace
else
    print_status "AeroSpace is already installed"
fi

print_status "All tools have been installed successfully!"

# Print post-installation notes
echo ""
print_status "Post-installation notes:"
echo "  • Fish is configured as the default login shell"
echo "  • For SketchyBar, enable 'Displays have separate Spaces' in System Settings → Desktop & Dock"
echo "  • Configure AeroSpace in ~/.config/aerospace/aerospace.toml"
echo ""
print_status "Installation completed! 🎉"

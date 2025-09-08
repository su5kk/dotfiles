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

# Install Starship
if ! formula_exists starship; then
    print_status "Installing Starship prompt..."
    brew install starship
else
    print_status "Starship is already installed"
fi

# Install SketchyBar
if ! formula_exists sketchybar; then
    print_status "Installing SketchyBar..."
    brew tap FelixKratz/formulae
    brew install sketchybar
    
    # Setup default configuration
    print_status "Setting up SketchyBar configuration..."
    mkdir -p ~/.config/sketchybar/plugins
    
    if [[ ! -f ~/.config/sketchybar/sketchybarrc ]]; then
        cp "$(brew --prefix)/share/sketchybar/examples/sketchybarrc" ~/.config/sketchybar/sketchybarrc
        print_status "Copied default sketchybarrc configuration"
    else
        print_warning "SketchyBar configuration already exists, skipping..."
    fi
    
    if [[ ! -d ~/.config/sketchybar/plugins ]] || [[ -z "$(ls -A ~/.config/sketchybar/plugins)" ]]; then
        cp -r "$(brew --prefix)/share/sketchybar/examples/plugins/"* ~/.config/sketchybar/plugins/
        chmod +x ~/.config/sketchybar/plugins/*
        print_status "Copied default SketchyBar plugins"
    else
        print_warning "SketchyBar plugins directory already exists and is not empty, skipping..."
    fi
else
    print_status "SketchyBar is already installed"
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
echo "  • To use Fish as your default shell, add it to /etc/shells and run: chsh -s \$(which fish)"
echo "  • For SketchyBar, enable 'Displays have separate Spaces' in System Settings → Desktop & Dock"
echo "  • Initialize Starship in your shell config:"
echo "    - Fish: Add 'starship init fish | source' to ~/.config/fish/config.fish"
echo "    - Bash: Add 'eval \"\$(starship init bash)\"' to ~/.bashrc"
echo "    - Zsh: Add 'eval \"\$(starship init zsh)\"' to ~/.zshrc"
echo "  • Configure AeroSpace in ~/.config/aerospace/aerospace.toml"
echo ""
print_status "Installation completed! 🎉"
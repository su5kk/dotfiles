set --export EDITOR /opt/homebrew/bin/nvim


# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
export PATH="$HOME/.local/bin:$PATH"


# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Pi
fish_add_path "$HOME/.local/share/fnm/node-versions/v24.11.1/installation/bin"

# pyenv
pyenv init - | source

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.fish.inc" ]; . "$HOME/google-cloud-sdk/path.fish.inc"; end

# Minimal Pure prompt.
set --global pure_enable_single_line_prompt true
set --global pure_enable_git true
set --global pure_enable_virtualenv false
set --global pure_enable_aws_profile false
set --global pure_enable_container_detection false
set --global pure_enable_k8s false

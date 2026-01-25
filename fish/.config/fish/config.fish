set --export EDITOR /opt/homebrew/bin/nvim

# opencode
fish_add_path $HOME/.opencode/bin

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
export PATH="$HOME/.local/bin:$PATH"

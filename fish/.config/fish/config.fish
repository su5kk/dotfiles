set --export EDITOR /opt/homebrew/bin/nvim

# opencode
fish_add_path /Users/temirlantursunov/.opencode/bin

# pnpm
set -gx PNPM_HOME "/Users/temirlantursunov/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
export PATH="$HOME/.local/bin:$PATH"

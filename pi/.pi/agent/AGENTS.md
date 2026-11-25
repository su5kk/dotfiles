# Global agent instructions

## Responses

- use /unslop skill at all times when writing prose. your answers are in chat are prose.

- Be very concise and direct. Say only what is necessary in the fewest words possible; avoid essays and unnecessary prose.
- Use Markdown hyperlinks for local code references with absolute `file:///` URLs as targets and short `filename:line` labels. Do not use relative targets or put `:line` suffixes or GitHub-style `#L...` fragments in file URLs. File links open the default application; line numbers in labels do not guarantee line navigation. For plain-text references, use absolute file paths with `:line` suffixes.

## Tooling

- Use `rg` (ripgrep) for searching file contents and `rg --files` for finding files. Never use `grep` or `find`.

## Git

- Never add `Co-authored-by` trailers or any other agent attribution to commit messages or PR descriptions.
- Never edit a PR description someone else changed after you created it. Before any update, compare the current body (`gh pr view --json body`) with the last version you wrote. If they differ, leave the description alone and tell the user what you would change.

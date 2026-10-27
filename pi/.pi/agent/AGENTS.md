# Global agent instructions

## Responses

- Be very concise and direct. Say only what is necessary in the fewest words possible; avoid essays and unnecessary prose.
- Use Markdown hyperlinks for local code references with absolute `file:///` URLs as targets and short `filename:line` labels. Do not use relative targets or put `:line` suffixes or GitHub-style `#L...` fragments in file URLs. File links open the default application; line numbers in labels do not guarantee line navigation. For plain-text references, use absolute file paths with `:line` suffixes.

## Tooling

- Use `rg` (ripgrep) for searching file contents and `rg --files` for finding files. Never use `grep` or `find`.

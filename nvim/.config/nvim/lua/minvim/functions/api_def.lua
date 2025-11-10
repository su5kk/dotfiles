----- @diagnostic disable: undefined-global
local M = {}

function M.find()
    local current_line = vim.fn.getline('.')
    local match = vim.fn.matchlist(current_line, '\\v"([^"]+)"')

    local path_to_search_inner
    if #match > 1 and match[2] ~= "" then
        path_to_search_inner = match[2]
    else
        vim.notify("Error: Could not find a quoted path string on the current line.", vim.log.levels.ERROR)
        return
    end

    local path_to_search_full = '"' .. path_to_search_inner .. '"'

    vim.notify("Searching for route: " .. path_to_search_full, vim.log.levels.INFO)

    local rg_cmd = { "rg", "--vimgrep", "-F", path_to_search_full }
    local rg_output_lines = vim.fn.systemlist(rg_cmd)

    if #rg_output_lines == 0 or (#rg_output_lines == 1 and rg_output_lines[1] == "") then
        vim.notify("No route definitions found for: " .. path_to_search_full, vim.log.levels.INFO)
        return
    end

    for _, line in ipairs(rg_output_lines) do
        local filename = vim.fn.split(line, ':')[1]
        if filename and vim.fn.fnamemodify(filename, ":t") == "Bootstrap.ts" then
            local linenum = vim.fn.split(line, ':')[2]
            vim.notify("Found route in Bootstrap.ts. Opening in new tab.", vim.log.levels.INFO)
            vim.cmd("tabnew " .. vim.fn.fnameescape(filename))
            if linenum and tonumber(linenum) then
                vim.cmd(linenum)
            end
            vim.cmd("normal! zz")
            return
        end
    end
end

return M

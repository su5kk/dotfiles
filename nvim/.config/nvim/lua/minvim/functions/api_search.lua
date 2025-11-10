--- @diagnostic disable: undefined-global

local M = {}

local function parse_rg_json(json_str)
    local lines = vim.split(json_str, '\n')
    local results = {}
    for _, line in ipairs(lines) do
        if line ~= "" then
            local ok, data = pcall(vim.fn.json_decode, line)
            if ok and data.type == "match" then
                table.insert(results, data.data)
            end
        end
    end
    return results
end

function M.find()
    -- captures "<everything that's not a ">"
    local match = vim.fn.matchlist(vim.fn.getline('.'), '\\v"([^"]+)"')

    if #match < 2 or match[2] == "" then
        vim.notify("Error: Could not find a quoted path string on the current line.", vim.log.levels.ERROR)
        return
    end

    local api_path_to_search = '"' .. match[2] .. '"'
    if not api_path_to_search or api_path_to_search == "" or api_path_to_search:sub(1, 1) ~= '"' then
        vim.notify("Error: Could not find a quoted path string. Place cursor on the path.", vim.log.levels.ERROR)
        return
    end

    local rg_input = "sendAsync.*" .. api_path_to_search
    local rg_cmd_1 = { "rg", "--json", "-m", "1", rg_input, "gen/asyncApi/" }
    local rg_output_1_json = vim.fn.system(rg_cmd_1)

    if vim.v.shell_error ~= 0 or rg_output_1_json == "" then
        vim.notify("Error: Could not find 'gen/asyncApi/' definition for path: " .. api_path_to_search, vim.log.levels.ERROR)
        return
    end

    local results_1 = parse_rg_json(rg_output_1_json)
    if #results_1 == 0 then
        vim.notify("Error: No match found for 'orFallback' definition: " .. api_path_to_search, vim.log.levels.ERROR)
        return
    end

    local def_match = results_1[1]
    local filename = def_match.path.text
    local linenum = def_match.line_number

    local file_content = vim.fn.readfile(filename)
    if not file_content or #file_content == 0 then
        vim.notify("Error: Could not read file: " .. filename, vim.log.levels.ERROR)
        return
    end

    local func_name = nil
    for i = linenum, 1, -1 do
        local current_line = file_content[i]
        -- looks for 'public functionName(' or 'public functionName<'
        local func_name_match = vim.fn.matchlist(current_line, '\\v^\\s*public\\s+(\\w+)\\s*[<(]')
        if #func_name_match > 1 then
            func_name = func_name_match[2]
            break
        end
    end

    if not func_name then
        vim.notify("Error: Could not extract function name from " .. filename, vim.log.levels.ERROR)
        return
    end

    vim.notify("Found asyncApi API name: " .. func_name, vim.log.levels.INFO)

    local file_basename = vim.fn.fnamemodify(filename, ":t")

    -- -w match whole words only.
    -- --vimgrep formats output for the quickfix list.
    local rg_cmd_2 = { "rg", "--vimgrep", "-w", func_name, "--glob", "!" .. file_basename }
    local rg_output_2_lines = vim.fn.systemlist(rg_cmd_2)

    if #rg_output_2_lines == 0 or (#rg_output_2_lines == 1 and rg_output_2_lines[1] == "") then
        vim.notify("No usages found for: " .. func_name, vim.log.levels.INFO)
        return
    end

    vim.fn.setqflist({}, ' ', { title = "Usages of " .. func_name, lines = rg_output_2_lines })
    vim.cmd("copen")
end

return M

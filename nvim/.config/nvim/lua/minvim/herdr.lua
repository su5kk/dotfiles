if not vim.env.HC_TERMINAL_ID or vim.fn.executable("hc") == 0 then
    return
end

local function register()
    vim.system({ "hc", "label", vim.env.HC_TERMINAL_ID, "nvim.server=" .. vim.v.servername }, {}, function(result)
        if result.code ~= 0 then
            vim.schedule(function()
                vim.notify("Herdr socket registration failed: " .. result.stderr, vim.log.levels.WARN)
            end)
        end
    end)
end

if vim.v.vim_did_enter == 1 then
    register()
else
    vim.api.nvim_create_autocmd("VimEnter", { once = true, callback = register })
end

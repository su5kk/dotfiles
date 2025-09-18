return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- lazydev.nvim is a plugin that properly configures LuaLS for editing your Neovim config by
        -- lazily updating your workspace libraries.
        {
            'folke/lazydev.nvim',
            ft = 'lua',
            opts = {
                library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            }
        },
        "hrsh7th/cmp-nvim-lsp",
        { "mason-org/mason.nvim",           version = "^1.0.0" },
        { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "jcha0713/cmp-tw2css",
        "hrsh7th/nvim-cmp",
    },

    config = function()
        vim.diagnostic.config({
            float = { border = "rounded" }
        })

        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        local servers = {
            gopls = { capabilities = capabilities },
            marksman = { capabilities = capabilities },
            rust_analyzer = { capabilities = capabilities },
            vtsls = {
                capabilities = capabilities,
                settings = {
                    complete_function_calls = true,
                    vtsls = {
                        enableMoveToFileCodeAction = true,
                        autoUseWorkspaceTsdk = true,
                        experimental = {
                            completion = {
                                enableServerSideFuzzyMatch = true,
                            },
                        },
                    },
                    javascript = {
                        updateImportsOnFileMove = { enabled = "always" },
                        suggest = {
                            completeFunctionCalls = true,
                        },
                        inlayHints = {
                            enumMemberValues = { enabled = true },
                            functionLikeReturnTypes = { enabled = true },
                            parameterNames = { enabled = "literals" },
                            parameterTypes = { enabled = true },
                            propertyDeclarationTypes = { enabled = true },
                            variableTypes = { enabled = false },
                        },
                    },
                    typescript = {
                        updateImportsOnFileMove = { enabled = "always" },
                        suggest = {
                            completeFunctionCalls = true,
                        },
                        inlayHints = {
                            enumMemberValues = { enabled = true },
                            functionLikeReturnTypes = { enabled = true },
                            parameterNames = { enabled = "literals" },
                            parameterTypes = { enabled = true },
                            propertyDeclarationTypes = { enabled = true },
                            variableTypes = { enabled = false },
                        },
                    },
                },
            },
            lua_ls = {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        telemetry = { enable = false },
                        -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                        diagnostics = { disable = { 'missing-fields' } },
                        hint = { enable = true },
                    },
                },
            },
        }
        local ensure_installed = vim.tbl_keys(servers or {})
        require("mason").setup()
        require("mason-lspconfig").setup({
            automatic_installation = false,
            ensure_installed = ensure_installed,
        })

        local l = vim.lsp
        for server, settings in pairs(servers) do
            l.config(server, settings)
            l.enable(server)
        end

        l.handlers["textDocument/hover"] = function(_, result, ctx, config)
            config = config or { border = "rounded", focusable = true }
            config.focus_id = ctx.method
            if not (result and result.contents) then
                return
            end
            local markdown_lines = l.util.convert_input_to_markdown_lines(result.contents)
            markdown_lines = vim.tbl_filter(function(line)
                return line ~= ""
            end, markdown_lines)
            if vim.tbl_isempty(markdown_lines) then
                return
            end
            return l.util.open_floating_preview(markdown_lines, "markdown", config)
        end

        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        vim.api.nvim_set_hl(0, "CmpNormal", {})
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ["<CR>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = false,
                }),
                ['<C-e>'] = vim.NIL
            }),

            window = {
                completion = {
                    scrollbar = false,
                    border = "rounded",
                    winhighlight = "Normal:CmpNormal",
                },
                documentation = {
                    scrollbar = false,
                    border = "rounded",
                    winhighlight = "Normal:CmpNormal",
                }
            },
            sources = cmp.config.sources({
                {
                    name = "nvim_lsp",
                    entry_filter = function(entry, ctx)
                        return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
                    end,
                },
                { name = 'cmp-tw2css' },
            }, {})
        })


        local autocmd = vim.api.nvim_create_autocmd

        autocmd('LspAttach', {
            callback = function(e)
                local opts = { buffer = e.buf }
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format)
                vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>re", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("n", "<leader>k", function() vim.diagnostic.open_float() end, opts)
            end
        })
    end
}

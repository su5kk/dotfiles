return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		opts = {
			-- configurations
			flavour = "mocha", -- latte, frappe, macchiato, mocha
			transparent_background = true, -- disables setting the background color.
		},
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin",
		},
	},
}

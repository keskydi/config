-- plugins/telescope.lua:
return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.6',
	dependencies = { 'nvim-lua/plenary.nvim' },
	otps = {
		defaults = {
			hidden = true,
			no_ignore = true,
			file_ignore_patterns = {
				"node_modules",
				".ruff_cache",
				".git/",
				".mypy_cache",
			},
		},
		pickers = {
			find_files = {
				hidden = true,
				no_ignore = true,
				file_ignore_patterns = {
					"node_modules",
					".ruff_cache",
					".git/",
					".mypy_cache",
				},
			},
		},
	},

	config = function()
		--Find files using Telescope command-line sugar.
		vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files find_command=rg,--files<cr>', {})
		vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep additional_args=--hidden<cr>', {})
		vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers hidden=true<cr>', {})
		vim.api.nvim_set_keymap('n', '<leader>b', '<cmd>Telescope buffers hidden=true<cr>', {})
		vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags hidden=true<cr>', {})
	end
}

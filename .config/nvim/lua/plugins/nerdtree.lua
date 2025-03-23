-- NERDTree
return {
	'scrooloose/nerdtree',
	config = function()
		vim.api.nvim_set_keymap('n', '<leader>nt', '<cmd>NERDTreeToggle<cr>', {})
	end
}

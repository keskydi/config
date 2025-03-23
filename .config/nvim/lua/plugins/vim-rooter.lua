-- auto-cd to root of git project
-- 'airblade/vim-rooter'
return {
	'notjedi/nvim-rooter.lua',
	config = function()
		require('nvim-rooter').setup()
	end
}

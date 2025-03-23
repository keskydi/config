	-- main color scheme
	-- {
	-- 	"loctvl842/monokai-pro.nvim",
	-- 	lazy = false, -- load at start
	-- 	priority = 1000, -- load first
	-- 	config = function()
	-- 		require('monokai-pro').setup()
	-- 		vim.g.monokai_term_italic = 1
	-- 		vim.g.monokai_gui_italic = 1
	--
	-- 	end
	-- },
return	{
		"tanvirtin/monokai.nvim",
		lazy = false, -- load at start
		priority = 1000, -- load first
		config = function()
			require('monokai').setup()
			vim.g.monokai_term_italic = 1
			vim.g.monokai_gui_italic = 1
			vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#87DFFF" })
		end
	}

return {
	'neovim/nvim-lspconfig',
	dependencies = {
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-path",
		"hrsh7th/nvim-cmp",
		"neovim/nvim-lspconfig",
		"mrcjkb/rustaceanvim",
		"L3MOD4D3/LuaSnip",
		{ 'mrcjkb/rustaceanvim', version = '^5', --[[ Recommended --]] lazy = false, --[[ This plugin is already lazy --]] },
	},
	opts = {
		inlay_hints = { enabled = true },
	},
	config = function()
		local lspconfig = require('lspconfig')

		-- Python
		lspconfig.pyright.setup {}

		-- -- Typescript , Javascript
		-- lspconfig.tsserver.setup {}

		-- Lua
		lspconfig.lua_ls.setup {
			on_init = function(client)
				local path = client.workspace_folders[1].name
				if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
					return
				end

				client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
					runtime = {
						-- Tell the language server which version of Lua you're using
						-- (most likely LuaJIT in the case of Neovim)
						version = 'LuaJIT'
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME
							-- Depending on the usage, you might want to add additional paths here.
							-- "${3rd}/luv/library"
							-- "${3rd}/busted/library",
						}
						-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
						-- library = vim.api.nvim_get_runtime_file("", true)
					}
				})
			end,
			settings = {
				Lua = {}
			}
		}

		local cmp = require 'cmp'
		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
					-- 		vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				-- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
				-- ['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				-- ['<C-e>'] = cmp.mapping.abort(),
				-- Accept currently selected item.
				-- Set `select` to `false` to only confirm explicitly selected items.
				['<C-y>'] = cmp.mapping.confirm({ select = true }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "nvim_lua" },
				{ name = "path" },
			}, {
				{ name = "buffer", keyword_length = 3 },
			}),

			experimental = {
				ghost_text = true,
			},
		})
	end
}

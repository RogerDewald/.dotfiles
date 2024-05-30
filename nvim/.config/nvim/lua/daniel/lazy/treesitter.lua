return {
	'nvim-treesitter/nvim-treesitter',
	name = "treesitter",
	config = function()
		require("nvim-treesitter/configs").setup{
			ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "java", "javascript", "html", "css", "cpp" },

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			indent = {
				enable = true
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
		}
	end
}

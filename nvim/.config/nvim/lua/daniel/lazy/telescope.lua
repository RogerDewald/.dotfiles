return {
	'nvim-telescope/telescope.nvim', tag = '0.1.6',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		require("telescope")
		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
		vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
		vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
	end
}

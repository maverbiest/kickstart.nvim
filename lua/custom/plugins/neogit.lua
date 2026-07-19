-- NeogitOrg/neogit — Magit-style git UI
-- (plenary is already provided by the base config's Telescope block, so it's not repeated here)
vim.pack.add {
	'https://github.com/sindrets/diffview.nvim',
	'https://github.com/NeogitOrg/neogit',
}

require('neogit').setup {}

vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = 'Show Neogit UI' })

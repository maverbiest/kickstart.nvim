-- folke/snacks.nvim — file explorer sidebar
vim.pack.add { 'https://github.com/folke/snacks.nvim' }

require('snacks').setup {
  explorer = { enabled = true },
  picker = { enabled = true },
}

vim.keymap.set('n', '<leader>e', function()
  Snacks.explorer()
end, { desc = 'Snacks Explorer' })

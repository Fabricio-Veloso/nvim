require 'core.options'
require 'core.keymaps'
-- NOTE:  lazy set-up
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- clip board with yank
vim.g.clipboard = {
  name = 'win32yank-wsl',
  copy = {
    ['+'] = 'win32yank.exe -i',
    ['*'] = 'win32yank.exe -i',
  },
  paste = {
    ['+'] = 'win32yank.exe -o',
    ['*'] = 'win32yank.exe -o',
  },
  cache_enabled = 0,
}
vim.opt.clipboard:prepend { 'unnamed', 'unnamedplus' }

require('lazy').setup {
  require 'plugins.neotree', require 'plugins.lualine',
  require 'plugins.nerdy',
  require 'plugins.treesitter',
  require 'plugins.moonfly',
  require 'plugins.telescope',
  require 'plugins.lsp',
  require 'plugins.autocompletion',
  require 'plugins.typescript-tools',
  require 'plugins.alpha',
  require 'plugins.indent-blankLine',
  --  require 'plugins.autoformatting',
  require 'plugins.comment',
  require 'plugins.autopairs',
  require 'plugins.neogit',
  --  require 'plugins.nvim-ghost',
  require 'plugins.neoscroll',
  require 'plugins.live-preview',
  require 'plugins.roslyn',
  require ("plugins.dap"),
  require 'plugins.which-key',
}

-- seting moonflw theme
vim.cmd [[colorscheme moonfly]]

-- Usa Treesitter para folding baseado em sintaxe real
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

-- Mostra apenas a primeira linha dentro do fold (ex: def func():)
vim.opt.foldtext = 'getline(v:foldstart)'
vim.opt.fillchars = { fold = ' ' } -- remove os "tracinhos" feios do fold

-- Abre todos os arquivos com os folds fechados (modo minimalista)
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    vim.schedule(function()
      vim.cmd 'normal! zM' -- fecha todos os folds automaticamente
    end)
  end,
})

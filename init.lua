require 'core.options'
require 'core.keymaps'
-- Configura o shell para PowerShell (Windows)
if vim.loop.os_uname().sysname == "Windows_NT" then
  local shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
  vim.o.shell = shell
  vim.o.shellcmdflag = '-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[\'Out-File:Encoding\']=\'utf8\';$PSStyle.OutputRendering=\'plaintext\';Remove-Item Alias:tee -ErrorAction SilentlyContinue'
  vim.o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
  vim.o.shellpipe  = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
  vim.o.shellquote = ''
  vim.o.shellxquote = ''
end

-- NOTE: lazy.nvim set-up
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Clipboard integration
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

-- Lazy.nvim plugins
require('lazy').setup {
  -- Plugins locais
  require("plugins.dap"),
  require("plugins.lf"),
  require('plugins.neotree'),
  require('plugins.lualine'),
  require('plugins.nerdy'),
  require('plugins.treesitter'),
  require('plugins.moonfly'),
  require('plugins.telescope'),
  require('plugins.lsp'),
  require('plugins.autocompletion'),
  require('plugins.typescript-tools'),
  require('plugins.alpha'),
  require('plugins.indent-blankLine'),
  -- require('plugins.autoformatting'), -- opcional
  require('plugins.comment'),
  require('plugins.autopairs'),
  require('plugins.neoscroll'),
  require('plugins.roslyn'),
  require('plugins.which-key'),
  require('plugins.telescope-fzf-native'),
  -- require('plugins.avante'), if new good features come out
  require('plugins.code-companion'),
  require('plugins.lsp-signature'),
  require('plugins.fire-nvim'),
  require('plugins.mcphub-nvim'),
  require('plugins.neogit'),
  require('plugins.markdown-preview')
}



-- Tema Moonfly
vim.opt.termguicolors = true
vim.cmd [[colorscheme moonfly]]

-- Automations

-- Folding com Treesitter
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldtext = 'getline(v:foldstart)'
vim.opt.fillchars = { fold = ' ' }

-- Fecha todos os folds ao abrir arquivo
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    vim.schedule(function()
      vim.cmd 'normal! zM'
    end)
  end,
})

-- Remove opacidade do Neovim
vim.cmd [[
  hi Normal guibg=NONE ctermbg=NONE
  hi NonText guibg=NONE ctermbg=NONE
]]

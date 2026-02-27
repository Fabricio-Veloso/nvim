return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim',
  },
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting

    require('mason-null-ls').setup {
      ensure_installed = {
        'prettier',
        'stylua',
        'eslint_d',
        'shfmt',
      },
      automatic_installation = true,
    }

    local sources = {
      -- Prettier geral (HTML incluído) - SEM plugin solidity
      formatting.prettier.with {
        prefer_local = 'node_modules/.bin',
        filetypes = {
          'html',
          'css',
          'javascript',
          'typescript',
          'json',
          'yaml',
          'markdown',
        },
      },

      -- Prettier só para Solidity (COM plugin)
      formatting.prettier.with {
        prefer_local = 'node_modules/.bin',
        filetypes = { 'solidity' },
        extra_args = { '--plugin=prettier-plugin-solidity' },
      },

      formatting.stylua,
      formatting.shfmt.with { args = { '-i', '2' } },
    }

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

    null_ls.setup {
      debug = true,
      sources = sources,
      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format {
                bufnr = bufnr,
                async = false,
                timeout_ms = 10000,
                filter = function(c)
                  return c.name == 'null-ls' or c.name == 'none-ls'
                end,
              }
            end,
          })
        end
      end,
    }
  end,
}

return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim',
  },
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    require('mason-null-ls').setup {
      ensure_installed = {
        'prettier', -- ts/js formatter
        'stylua',
        'eslint_d',
        'shfmt',
      },
      automatic_installation = true,
    }

    local sources = {
      null_ls.builtins.diagnostics.solhint,
      formatting.prettier.with {
        prefer_local = 'node_modules/.bin',
        filetypes = { 'solidity', 'javascript', 'typescript', 'json', 'yaml', 'markdown', 'html' },
        extra_args = { '--plugin=prettier-plugin-solidity' },
      },
      formatting.stylua,
      formatting.shfmt.with { args = { '-i', '2' } },
      -- formatting.terraform_fmt, -- remova se não usa
      -- require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
      -- require('none-ls.formatting.ruff_format'),
    }

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

    null_ls.setup {
      debug = true, -- por enquanto, pra enxergar qualquer erro no log
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

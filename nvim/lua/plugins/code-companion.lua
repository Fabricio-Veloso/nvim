-- Esse plugin precisa de: :TSInstall markdown markdown_inline,
-- ripgrep instalado e no path
return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    extensions = {
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          make_vars = true,
          make_slash_commands = true,
          show_result_in_chat = true
        }
      }
    },
    strategies = {
      chat = {
        adapter = 'ollama',
        inline = 'ollama',
      },
    },
    adapters = {
      http = {
        ollama = function()
          return require('codecompanion.adapters').extend('ollama', {
            name = 'ollama',
            schema = {
              model = {
                default = 'qwen2.5-coder:7b',
              },
            },
          })
        end,
      },
    },
    tools = {
      groups = {
        ["full_stack_dev"] = {
          description = "Full Stack Developer - Can run code, edit code and modify files",
          prompt = "I'm giving you access to the ${tools} to help you perform coding tasks",
          tools = {
            "cmd_runner",
            "create_file",
            "file_search",
            "get_changed_files",
            "grep_search",
            "insert_edit_into_file",
            "list_code_usages",
            "read_file",
          },
          opts = {
            collapse_tools = true,
          },
        },
      },

      ["create_file"] = {
        callback = "strategies.chat.tools.catalog.create_file",
        description = "Create a file in the current working directory",
        opts = {
          requires_approval = true,
        },
      },
      ["insert_edit_into_file"] = {
        callback = "strategies.chat.tools.catalog.insert_edit_into_file",
        description = "Insert code into an existing file",
        opts = {
          requires_approval = { buffer = false, file = true },
          user_confirmation = true,
        },
      },
      ["read_file"] = {
        callback = "strategies.chat.tools.catalog.read_file",
        description = "Read a file in the current working directory",
      },
      ["grep_search"] = {
        callback = "strategies.chat.tools.catalog.grep_search",
        description = "Search for text in the current working directory",
        opts = { max_results = 100, respect_gitignore = true },
      },
    },

    opts = {
      log_level = 'DEBUG',
    },

    display = {
      action_palette = {
        width = 95,
        height = 10,
        prompt = "Prompt ",
        provider = "default",
        opts = {
          show_default_actions = true,
          show_default_prompt_library = true,
          title = "CodeCompanion actions",
        },
      },

      chat = {
        icons = {
          buffer_pin = " ",
          buffer_watch = "👀 ",
        },

        debug_window = {
          width = vim.o.columns - 5,
          height = vim.o.lines - 2,
        },

        window = {
          layout = "vertical",
          position = nil,
          border = "single",
          height = 0.8,
          width = 0.45,
          relative = "editor",
          full_height = true,
          sticky = false,
          opts = {
            breakindent = true,
            cursorcolumn = false,
            cursorline = false,
            foldcolumn = "0",
            linebreak = true,
            list = false,
            numberwidth = 1,
            signcolumn = "no",
            spell = false,
            wrap = true,
          },
        },

        token_count = function(tokens, adapter)
          return " (" .. tokens .. " tokens)"
        end,
      },

      diff = {
        enabled = true,
        provider = nil, -- será atribuído abaixo no config
        provider_opts = {
          inline = {
            layout = "float",
            diff_signs = {
              signs = {
                text = "▌",
                reject = "✗",
                highlight_groups = {
                  addition = "DiagnosticOk",
                  deletion = "DiagnosticError",
                  modification = "DiagnosticWarn",
                },
              },
              icons = {
                accepted = " ",
                rejected = " ",
              },
              colors = {
                accepted = "DiagnosticOk",
                rejected = "DiagnosticError",
              },
            },
            opts = {
              context_lines = 3,
              dim = 25,
              full_width_removed = true,
              show_keymap_hints = true,
              show_removed = true,
            },
          },

          split = {
            close_chat_at = 240,
            layout = "vertical",
            opts = {
              "internal",
              "filler",
              "closeoff",
              "algorithm:histogram",
              "indent-heuristic",
              "followwrap",
              "linematch:120",
            },
          },
        },
      },
    },
  },

  config = function(_, opts)
    -- Importa providers antes de usar
    local providers = require("codecompanion.providers")
    opts.display.diff.provider = providers.diff

    require('codecompanion').setup(opts)

    -- Keymaps recomendados
    vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

    -- Alias 'cc' para 'CodeCompanion' no command line
    vim.cmd([[cab cc CodeCompanion]])
  end,
}

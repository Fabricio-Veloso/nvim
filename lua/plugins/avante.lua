return {
  "yetone/avante.nvim",
  build = vim.fn.has("win32") ~= 0
      and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make BUILD_FROM_SOURCE=true",
  event = "VeryLazy",
  version = false,
  opts = {
    instructions_file = "avante.md",
    provider = "ollama",
    providers = {
      ollama = {
        endpoint = "http://127.0.0.1:11434", -- endpoint correto
        model = "llama3.1:8b",
        disable_tools = false, -- ⚠️ necessário para escrever no buffer
        -- Patch para Windows: força streaming completo e Markdown
        stream_handler = function(chunk)
          -- remove tool-calling JSON e junta texto puro
          if type(chunk) == "table" and chunk.response then
            return chunk.response
          end
          return ""
        end,
        preamble = [[
          Você é um assistente de código.
          Sempre responda em Markdown puro.
          Não inclua tool-calls adicionais.
        ]],
      },
    },
    behaviour = {
      auto_apply_diff_after_generation = true, -- aplica automaticamente no buffer
      auto_suggestions = false,
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
    },
    mappings = {
      suggestion = {
        accept = "<M-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
      submit = {
        normal = "<CR>",
        insert = "<C-s>",
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "stevearc/dressing.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = { file_types = { "markdown", "Avante" } },
      ft = { "markdown", "Avante" },
    },
  },
}

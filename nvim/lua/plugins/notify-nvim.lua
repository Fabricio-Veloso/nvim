return{
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")
    notify.setup({
      -- Aqui você pode colocar configs personalizadas
      stages = "fade_in_slide_out",
      top_down = true,
      minimum_width = 50,
      background_colour = "#000000",
      level = 2,
      timeout = 5,
      fps = 60,
      icons = {
        DEBUG = "",
        ERROR = "",
        INFO = "",
        TRACE = "✎",
        WARN = ""
      },
      render = "simple",
    })
    vim.notify = notify
  end
}

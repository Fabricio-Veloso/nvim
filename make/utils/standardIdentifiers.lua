local M = {}

function M.getProjectRoot()
  return vim.fn.getcwd()
end

function M.getFileType()
  return vim.bo.filetype
end

function M.LanguageRouteCaller()

  local handlers = {
    python = "py-make.init",
    javascript = "js-make.init",
  }

  local ft = vim.bo.filetype
  local module = handlers[ft]
  

  if module then
    require(module).run()
  else
    print("Nenhum make handler registrado para filetype: " .. ft)
  end

end

return M 

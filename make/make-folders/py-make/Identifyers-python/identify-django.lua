local IdentifiyDjangoProject = {}
M.init()

  local stdi = require("make.utils.standardIdentifiers")
  local cwd = stdi.getProjectRoot()
  local managePyPath = vim.fn.findfile('manage.py','cwd','5')
  -- procura pelo manage.py
  if vim.fn.filewritable(managePyPath)  
    local     vim.fn.readfile(managePyPath)
  end
    
-- procura por "from django.core.management import execute_from_command_line" no manage.python
-- se houver, passa as funções de make para o projeto django e arquivos pythons isolados para o makeprg.
-- which-key recebe as opções de make diferente e mostra para o usuário ?
-- usuário pode escolher qual comando usar com as opções do which-key?
-- rotina  de make específica é iniciada?
end

function handler(filename)
end
return M

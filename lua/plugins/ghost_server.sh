# ~/.config/nvim/ghost_server.sh

#!/bin/bash

# Inicia o GhostText ouvindo em 127.0.0.1:4001
nvim --headless --listen 127.0.0.1:4001 -c "lua require('nvim-ghost').setup{}" -c "GhostStart"

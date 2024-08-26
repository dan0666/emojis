fx_version 'cerulean'
game 'gta5'
author 'International systems'
description 'Emoji'
version '1.0'
lua54 'yes'

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua' 
}

ui_page {
    'html/index.html'
}
files {
    'html/index.html'
}
escrow_ignore {
    'client/*.lua',
    'server/*.lua' 
}
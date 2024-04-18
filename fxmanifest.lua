fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Mads'
description 'Hookers'
version '1.1.0'

shared_script 'config.lua'

client_scripts {
    'menu.lua',
    'client.lua'
}

server_script 'server.lua'

dependencies {
	'/gameBuild:2060' -- Needed due to usage of game events.
}


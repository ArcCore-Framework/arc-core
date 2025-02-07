fx_version 'cerulean'
game 'gta5'

description 'Arc-Core'
version '0.1'

client_scripts {
    'client/main.lua',
    'shared/shared.lua',
    'client/testing.lua',
    'client/spawn.lua'
}

server_scripts {
    'server/main.lua',
    'shared/shared.lua',
    'server/commands.lua'
}

lua54 'yes'
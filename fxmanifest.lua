fx_version 'cerulean'
game 'gta5'

description 'Arc-Core'
version '0.1'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'client/main.lua',
    'shared/shared.lua',
    'client/testing.lua',
    'client/spawn.lua',
    'client/helpers.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'shared/shared.lua',
    'server/commands.lua'
}

lua54 'yes'
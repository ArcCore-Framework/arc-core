fx_version 'cerulean'
game 'gta5'

description 'Arc-Core'
version '0.1'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/sh_config.lua',
}

client_scripts {
    'client/main.lua',
    'shared/cl_config.lua',
    'client/testing.lua',
    'client/spawn.lua',
    'client/helpers.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'shared/sv_config.lua',
    'server/commands.lua'
}

lua54 'yes'
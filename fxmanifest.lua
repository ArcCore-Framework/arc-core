fx_version 'cerulean'
game 'gta5'

description 'Arc-Core'
version '0.1'

shared_script {
    '@ox_lib/init.lua',
    'shared/*.lua'
}

server_scripts {
    'server/*.lua',
    
    '@oxmysql/lib/MySQL.lua',
}

client_script {
    'client/*.lua'
}

lua54 'yes'
use_fxv2_oal 'yes'

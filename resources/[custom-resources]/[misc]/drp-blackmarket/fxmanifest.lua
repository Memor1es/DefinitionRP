fx_version 'adamant'

game 'gta5'

client_scripts {
    '@tprp_base/locale.lua',
    'locales/en.lua',
    'locales/es.lua',
    'config.lua',
    'client/main.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@tprp_base/locale.lua',
    'locales/en.lua',
    'locales/es.lua',
    'config.lua',
    'server/main.lua'
}
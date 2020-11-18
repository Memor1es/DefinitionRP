fx_version 'cerulean'
games { 'gta5' }

client_scripts {
    "config/*",
    "client/tp-framework_c.lua",
    "client/addons/*"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config/*",
    "server/tp-framework_s.lua",
    "server/addons/*"
}
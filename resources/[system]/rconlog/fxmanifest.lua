client_script 'rconlog_client.lua'

server_scripts {
    'rconlog_server.lua',
    '@mysql-async/lib/MySQL.lua',
}


fx_version 'adamant'
games { 'gta5', 'rdr3' }

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

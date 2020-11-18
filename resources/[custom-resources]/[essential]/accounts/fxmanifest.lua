fx_version 'cerulean'
games { 'gta5' }

description 'Accounts'

version '1.0.1'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/classes/addonaccount.lua',
	'server/main.lua'
}

dependency 'tprp_base'
fx_version 'cerulean'
games { 'gta5' }

description 'Billing'

version '1.1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@tprp_base/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@tprp_base/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

dependency 'tprp_base'
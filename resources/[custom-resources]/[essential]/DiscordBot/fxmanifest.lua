fx_version 'cerulean'
games { 'gta5' }

description 'Discord Bot' 			-- Resource Description

server_scripts {						-- Server Scripts
	'Config.lua',
	'SERVER/Server.lua',
	'@mysql-async/lib/MySQL.lua',
}

client_scripts {						-- Client Scripts
	'Config.lua',
	'CLIENT/Weapons.lua',
	'CLIENT/Client.lua',
}


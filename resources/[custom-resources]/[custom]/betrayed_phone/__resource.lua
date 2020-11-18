resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_script "@mysql-async/lib/MySQL.lua"

ui_page 'html/ui.html'
files {
	'html/icons/*.png',
	'html/icons/*.gif',
	'html/ui.html',
	'html/gurgle.png',
	'html/pricedown.ttf',
	'html/cursor.png',
	'html/background.png',
	'html/fondo.jpg',
	'html/backgroundwhite.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js',
	'html/timeago.js',
}

client_scripts {
	'config.lua',
	'client/open.lua',
	'client/main.lua',
	'client/yellowpages.lua',
	'client/services.lua',
	'client/calls.lua',
	'client/eWallet.lua',
	'client/appstore.lua',
	'client/contacts.lua',
	'client/functions.lua',
	'client/photos.lua',
	'client/twitter.lua',
	'client/animations.lua',
}

server_script {
	'config.lua',
	"server/server.lua",
	"server/llamados.lua",
	"server/funciones.lua",
	}

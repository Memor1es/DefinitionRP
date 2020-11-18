fx_version 'cerulean'
games { 'gta5' }

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/js/config.default.js',
  'html/js/App.js',
  'html/js/Message.js',
  'html/js/Suggestions.js',
  'html/vendor/vue.2.3.3.min.js',
  'html/vendor/flexboxgrid.6.3.1.min.css',
  'html/vendor/animate.3.5.2.min.css',
  'html/vendor/latofonts.css',
  'html/vendor/fonts/LatoRegular.woff2',
  'html/vendor/fonts/LatoRegular2.woff2',
  'html/vendor/fonts/LatoLight2.woff2',
  'html/vendor/fonts/LatoLight.woff2',
  'html/vendor/fonts/LatoBold.woff2',
  'html/vendor/fonts/LatoBold2.woff2',
  'html/css/style.css',
}

client_scripts {
  'client/cl_chat.lua',
  'client/commands.lua',
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/utils.lua',
  'server/commands.lua',
  'server/sv_chat.lua',
  'server/main.lua',
}

chat_theme 'gtao' {
    styleSheet = 'style.css',
    msgTemplates = {
        default = '<b>{0}</b><span>{1}</span>'
    }
}
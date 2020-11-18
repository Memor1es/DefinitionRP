resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page 'html/furniture.html'

client_scripts {
  'config.lua',
  'utils.lua',
  'disablecontrols.lua',
  'client.lua',
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'config.lua',
  'credentials.lua',
  'utils.lua',
  'server.lua',
}

files {
  'html/furniture.html',
  'html/aim.png',
  'html/back.png',
  'html/cancel.png',
  'html/dec.png',
  'html/down.png',
  'html/edit.png',
  'html/exit.png',
  'html/forward.png',
  'html/icon1.png',
  'html/inc.png',
  'html/left.png',
  'html/remove.png',
  'html/right.png',
  'html/slide.png',
  'html/test.png',
  'html/up.png',

  'html/affirm-detuned.wav',
  'html/affirm-melodic2.wav',
  'html/affirm-melodic3.wav',
  'html/alert-echo.wav',
  'html/camera_click.wav',
  'html/click-analogue-1.wav',
  'html/click-round-pop-1.wav',
  'html/click-round-pop-2.wav',
  'html/click-round-pop-3.wav',
}

dependencies = {
  'meta_libs',
}
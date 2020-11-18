resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'
files {
    -- Main
    'drp.html',
    'drp.css',
    'images/image1.jpg',
    'images/image2.jpg',
    'images/image3.jpg',
    
    -- Musiken
    'music/music.mp3'
}
client_script "client.lua"
loadscreen_manual_shutdown "yes"
loadscreen 'drp.html'

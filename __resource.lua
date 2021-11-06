fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/styles.css',
	'html/scripts.js',
	'html/img/*.png',
}

shared_script 'Config.lua'

client_script {
	'Client/*.lua'
}

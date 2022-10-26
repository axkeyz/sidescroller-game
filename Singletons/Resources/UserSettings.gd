extends Resource

export var lobby_characters = {
	"character": "Baxton",
	"expression": "default",
	"position": [0.0, 0.0],
	"scale": 1.0
}

export var game_quality = {
	"fps": 60,
	"quality": "medium",
	"gpu": "enable"
}

export var sound = {
	"music": 50,
	"sfx": 50,
	"ui": 50,
	"voices": 0,
	"enable_all": true,
	"notifications": {
		"enable_all": true,
		"craft": true,
		"dispatch": true,
		"chat": true,
	}
}

export var language = {
	"voice": "none",
	"text": "english",
}

export var battle = {
	"auto": false,
	"auto_special": false,
	"show_damage": true,
	"show_buffs": true,
	"show_special": true,
	"tracking": true,
	"show_advantages": true,
	"unit_alignment": "left",
}

export var user = {
	"streaming_settings": false,
	"gacha_warning": true,
}

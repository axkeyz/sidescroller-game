extends Node2D

var user_settings := preload("res://Resources/User/UserSettings.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_user_sprite()

func set_user_sprite():
	var lobby_sprite := $Background/Sprite
	var user_lobby : Dictionary = user_settings.lobby_characters
	
	var hero_sprite : String = "res://Assets/Heroes/%s/Sprite.png" % user_lobby["character"]
	
	lobby_sprite.texture = Utils.create_img_texture_from_img(hero_sprite)
	lobby_sprite.offset = Vector2(user_settings.lobby_characters["position"][0], 
		user_settings.lobby_characters["position"][1])
	
	lobby_sprite.texture.set_size_override(lobby_sprite.texture.size * user_lobby["scale"])

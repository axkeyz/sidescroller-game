extends Node2D

onready var server_connection := $ServerConnection
onready var debug_panel := $StartMenu/Background/M/VB/HB/VBLeft/ServerLabel

func _ready() -> void:
# warning-ignore:return_value_discarded
	get_node("StartMenu/Background").connect("pressed", self, "on_startgame_pressed")
# warning-ignore:return_value_discarded
	get_node("StartMenu/Background/M/VB/HB/VBRight/LogoutButton").connect("pressed", self, "on_end_game_pressed")
	
	# Connect nakama server
	var email := "test@test.com"
	var password := "password"
	
	debug_panel.text  = "Authenticating %s" % email
	var result : int = yield(server_connection.authenticate_async(email, password), "completed")
	
	if result == OK:
		debug_panel.text = "Authenticated user successfully"
	else:
		debug_panel.text = "Failed to authenticate user"


func on_startgame_pressed():
	# Remove StartMenu
	get_node("StartMenu").queue_free()
	
	# Add Lobby Scene
	var lobby_scene = load("res://Scenes/Main/LobbyScene.tscn").instance()
	add_child(lobby_scene)

func on_end_game_pressed():
	# Remove all nodes and quit
	get_tree().quit()

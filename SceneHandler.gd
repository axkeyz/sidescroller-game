extends Node2D

func _ready():
	get_node("StartMenu/Background").connect("pressed", self, "on_startgame_pressed")
	get_node("StartMenu/Background/M/VB/HB/VBRight/LogoutButton").connect("pressed", self, "on_end_game_pressed")

func on_startgame_pressed():
	# Remove StartMenu
	get_node("StartMenu").queue_free()
	
	# Add Lobby Scene
	var lobby_scene = load("res://Scenes/Main/LobbyScene.tscn").instance()
	add_child(lobby_scene)

func on_end_game_pressed():
	# Remove all nodes and quit
	get_tree().quit()

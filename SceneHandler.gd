extends Node2D

var user := load("res://Resources/User/UserDetails.tres")

onready var server_connection := $ServerConnection
onready var start_menu := $StartMenu/Background
onready var debug_panel := $StartMenu/Background/M/VB/HB/VBLeft/ServerLabel
onready var device_id := OS.get_unique_id()

func _ready() -> void:
# warning-ignore:return_value_discarded
	$StartMenu/Background/M/VB/HB/VBRight/LogoutButton.connect("pressed", self, "on_end_game_pressed")
	
	# Connect nakama server
	authenticate_user()

func authenticate_user():
	debug_panel.text = "AUTH_BEGIN"
	
	# Connect nakama server
	# TODO: Authenticate via other methods first before device_id
	if user.identity["device_id"] != "":
		authenticate_by_device()
	else:
		# TODO: load the register / login panel
		pass

func authenticate_existing_nakama_user(email: String) -> void:
	var password : String = user.identity["password"]
	
	var result : int = yield(server_connection.authenticate_async(email, password), "completed")
	read_auth_result(result)
	

func authenticate_by_device() -> void:
	save_guest_user_details_to_local()
	
	var result : int = yield(server_connection.guest_login_async(user.identity["id"]), "completed")
	read_auth_result(result)

func read_auth_result(result: int) -> void:
	if result == OK:
		on_auth_success()
	else:
		on_auth_failed()

func on_auth_failed() -> void:
	debug_panel.text = "AUTH_FAILED"
	
	# Attempt to reauthenticate if the user presses auth button
	# warning-ignore:return_value_discarded
	if not start_menu.is_connected("pressed", self, "authenticate_user"):
		start_menu.connect("pressed", self, "authenticate_user")

func on_auth_success() -> void:
	if start_menu.is_connected("pressed", self, "authenticate_user"):
		start_menu.disconnect("pressed", self, "authenticate_user")
		
	debug_panel.text = "AUTH_SUCCESS"
# warning-ignore:return_value_discarded
	start_menu.connect("pressed", self, "on_startgame_pressed")

func save_guest_user_details_to_local() -> void:
	if user.identity["id"] == "":
		user.identity["id"] = "user#%s" % Utils.generate_unique_string(8)
	
	if user.identity["device_id"] == "":
		user.identity["device_id"] = device_id
# warning-ignore:return_value_discarded
	ResourceSaver.save("res://Resources/User/UserDetails.tres", user)

func on_startgame_pressed():
	# Add Lobby Scene
	var lobby_scene = load("res://Scenes/Main/LobbyScene.tscn").instance()
	add_child(lobby_scene)
	
	# Remove StartMenu
	get_node("StartMenu").queue_free()

func on_end_game_pressed():
	Utils.remove_all_signals(start_menu)
	
	var result : int = yield(server_connection.logout_async(), "cpmpleted")
	
	if result == OK:
		debug_panel.text = "LOGOUT_SUCCESS"
	else:
		debug_panel.text = "LOGOUT_FAILED"

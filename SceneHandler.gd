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
	# Connect nakama server
	var email : String = user.identity["email"]
	
	if user.identity["email"] != "":
		authenticate_existing_nakama_user(email)
	else:
		reauthenticate_or_register_user()

func authenticate_existing_nakama_user(email: String) -> void:
	var password : String = user.identity["password"]
	
	debug_panel.text  = "Authenticating %s" % email
	var result : int = yield(server_connection.authenticate_async(email, password), "completed")
	
	if result == OK:
		on_auth_success()
	else:
		debug_panel.text = "AUTH_FAILED"
	

func reauthenticate_or_register_user() -> void:
	register_guest_user()
	## TODO: Add login
	pass

func register_guest_user() -> void:
	debug_panel.text = "CREATE_GUEST_USER"
	
	save_guest_user_details_to_local()
	
	var result : int = yield(server_connection.guest_login_async(user.identity["id"]), "completed")
	
	if result == OK:
		on_auth_success()
	else:
		debug_panel.text = "AUTH_FAILED"
# warning-ignore:return_value_discarded
		start_menu.connect("pressed", self, "authenticate_user")


func on_auth_success() -> void:
	if start_menu.is_connected("pressed", self, "authenticate_user"):
		start_menu.disconnect("pressed", self, "authenticate_user")
		
	debug_panel.text = "AUTH_SUCCESS"
# warning-ignore:return_value_discarded
	start_menu.connect("pressed", self, "on_startgame_pressed")

func save_guest_user_details_to_local() -> void:
	user.identity["id"] = "user#%s" % Utils.generate_unique_string(8)
	user.identity["device"].append(device_id)
# warning-ignore:return_value_discarded
	ResourceSaver.save("res://Resources/User/UserDetails.tres", user)

func on_startgame_pressed():
	# Remove StartMenu
	get_node("StartMenu").queue_free()
	
	# Add Lobby Scene
	var lobby_scene = load("res://Scenes/Main/LobbyScene.tscn").instance()
	add_child(lobby_scene)

func on_end_game_pressed():
	Utils.remove_all_signals(start_menu)
	
	server_connection.logout_async()

	debug_panel.text = "LOGOUT_SUCCESS"

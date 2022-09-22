extends Node2D

var user := load("res://Resources/User/UserDetails.tres")

onready var server_connection := $ServerConnection
onready var debug_panel := $StartMenu/Background/M/VB/HB/VBLeft/ServerLabel

func _ready() -> void:
# warning-ignore:return_value_discarded
	get_node("StartMenu/Background").connect("pressed", self, "on_startgame_pressed")
# warning-ignore:return_value_discarded
	get_node("StartMenu/Background/M/VB/HB/VBRight/LogoutButton").connect("pressed", self, "on_end_game_pressed")
	
	# Connect nakama server
	authenticate_user()

func authenticate_user():
	# Connect nakama server
	var email : String = user.identity["email"]
	
	if email != "":
		authenticate_existing_nakama_user(email)
	else:
		reauthenticate_or_register_user()
	

func authenticate_existing_nakama_user(email: String) -> void:
	var password : String = user.identity["password"]
	
	debug_panel.text  = "Authenticating %s" % email
	var result : int = yield(server_connection.authenticate_async(email, password), "completed")
	
	if result == OK:
		debug_panel.text = "Authenticated user successfully"
	else:
		debug_panel.text = "Failed to authenticate user"
	

func reauthenticate_or_register_user() -> void:
	register_guest_user()
	## TODO: Add login
	pass

func register_guest_user() -> void:
	debug_panel.text = "Creating guest user..."
	
	save_guest_user_details_to_local()
	
	var result : int = yield(server_connection.guest_login_async(user.identity["id"]), "completed")
	
	if result == OK:
		debug_panel.text = "Created guest user successfully"
	else:
		debug_panel.text = "Failed to authenticate user"
	pass

func save_guest_user_details_to_local() -> void:
	user.identity["id"] = "user#%s" % Utils.generate_unique_string(8)
	user.identity["device"].append(OS.get_unique_id())
	ResourceSaver.save("res://Resources/User/UserDetails.tres", user)

func on_startgame_pressed():
	# Remove StartMenu
	get_node("StartMenu").queue_free()
	
	# Add Lobby Scene
	var lobby_scene = load("res://Scenes/Main/LobbyScene.tscn").instance()
	add_child(lobby_scene)

func on_end_game_pressed():
	# Remove all nodes and quit
	get_tree().quit()

extends Node2D

var user := load("res://Resources/User/UserDetails.tres")

onready var server_connection := $ServerConnection
onready var start_menu := $StartMenu/Background
onready var debug_panel := $StartMenu/Background/M/VB/HB/VBLeft/ServerLabel
onready var logout_button := $StartMenu/Background/M/VB/HB/VBRight/LogoutButton

func _ready() -> void:
	# Connect nakama server
	authenticate_user()
	
	var e := logout_button.connect("pressed", self, "on_end_game_pressed")
	Utils.print_error_code(e)

func authenticate_user():
	debug_panel.text = "AUTH_BEGIN"
	
	# Connect nakama server
	# TODO: Authenticate via other methods first before device_id
	if user.identity["guest"]:
		start_create_guest_account()
	else:
		authenticate_by_device(user.identity["id"])

func start_create_guest_account() -> void:
	if not start_menu.is_connected("pressed", self, "show_SetUsernamePopup"):
		var error = start_menu.connect("pressed", self, "show_SetUsernamePopup")
		Utils.print_error_code(error)

func authenticate_by_device(username: String) -> void:
	var result : int = yield(server_connection.guest_login_async(username, user.identity["guest"]), "completed")
	read_auth_result(result)

func show_SetUsernamePopup() -> void:
	$StartMenu/SetUsernamePopup.visible = true
	
	# Connect successful register_username signal to authenticate_by_device method
	if not $StartMenu/SetUsernamePopup.is_connected("register_username", self, "authenticate_by_device"):
		var error = $StartMenu/SetUsernamePopup.connect("register_username", self, "authenticate_by_device")
		Utils.print_error_code(error)

func hide_SetUsernamePopup() -> void:
	if start_menu.is_connected("pressed", self, "show_SetUsernamePopup"):
		start_menu.disconnect("pressed", self, "show_SetUsernamePopup")
		$StartMenu/SetUsernamePopup.visible = false

func on_auth_failed() -> void:
	debug_panel.text = "AUTH_FAILED"

	# Attempt to reauthenticate if the user presses auth button
	if not start_menu.is_connected("pressed", self, "authenticate_user"):
		var e := start_menu.connect("pressed", self, "authenticate_user")
		Utils.print_error_code(e)

func on_auth_success() -> void:
	if start_menu.is_connected("pressed", self, "authenticate_user"):
		start_menu.disconnect("pressed", self, "authenticate_user")
	
	logout_button.show()

	hide_SetUsernamePopup()
	
	debug_panel.text = "AUTH_SUCCESS"

	var e := start_menu.connect("pressed", self, "on_startgame_pressed")
	Utils.print_error_code(e)

func read_auth_result(result: int) -> void:
	if result == OK:
		on_auth_success()
	else:
		on_auth_failed()

func on_startgame_pressed():
	# Add Lobby Scene
	var lobby_scene = load("res://Scenes/Main/LobbyScene.tscn").instance()
	add_child(lobby_scene)

	# Remove StartMenu
	get_node("StartMenu").queue_free()
#
func on_end_game_pressed():
	Utils.remove_all_signals(start_menu)
	
	var result := OK
	
	if user.identity["device_id"] != "":
		var _test = yield(server_connection.create_guest_linked_account(user.identity), "completed")

	if result == OK:
		debug_panel.text = "LOGOUT_SUCCESS"
	else:
		debug_panel.text = "LOGOUT_FAILED"
	
	logout_button.hide()
	
	authenticate_user()

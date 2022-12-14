extends Node

const KEY := "axkeyz_sidescroller"

var _session : NakamaSession

var _client := Nakama.create_client(KEY, "127.0.0.1", 7350, "http")

var device_id := OS.get_unique_id()

func guest_login_async(username: String, is_guest: bool) -> int:
	var result := OK
	
	var new_session : NakamaSession = yield(
		_client.authenticate_device_async(device_id, username, is_guest), "completed"
	)
	
	if new_session.is_exception():
		get_parent().get_node("StartMenu/SetUsernamePopup/M/V/Start/V/WarningLabel").text = "%s" % new_session.get_exception().message
	else:
		save_user_details(new_session.username)

	result = update_async_result(new_session, result)

	return result

func authenticate_async(email: String, password: String, register := false) -> int:
	var result := OK
	
	var new_session : NakamaSession = yield(
		_client.authenticate_email_async(email, password, null, register), "completed"
	)
	
	result = update_async_result(new_session, result)
	
	return result

func update_async_result(session: NakamaSession, result: int) -> int:
	if not session.is_exception():
		_session = session
	else:
		result = session.get_exception().status_code
	
	return result


func create_guest_linked_account(user: Dictionary) -> int:
	var error = FAILED
	
	var result : NakamaAsyncResult = yield(
		_client.link_custom_async(_session, user["id"]+"$"+device_id), "completed"
	)
	
	if not result.is_exception():
		result = yield(
			_client.unlink_device_async(_session, device_id), "completed"
		)
		
		if not result.is_exception():
			reset_user_details()
			error = OK
	
	return error

func save_user_details(username: String) -> void:
	var user := load("res://Resources/User/UserDetails.tres")
	
	user.identity["id"] = username

	if user.identity["device_id"] == "":
		user.identity["device_id"] = device_id
	
	user.identity["guest"] = false
	
# warning-ignore:return_value_discarded
	ResourceSaver.save("res://Resources/User/UserDetails.tres", user)

func reset_user_details() -> void:
	var user := load("res://Resources/User/UserDetails.tres")
	
	user.identity["id"] = ""
	user.identity["device_id"] = ""
	user.identity["guest"] = true
	
# warning-ignore:return_value_discarded
	ResourceSaver.save("res://Resources/User/UserDetails.tres", user)

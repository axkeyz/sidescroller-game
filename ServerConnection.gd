extends Node

const KEY := "axkeyz_sidescroller"

var _session : NakamaSession

var _client := Nakama.create_client(KEY, "127.0.0.1", 7350, "http")

func guest_login_async(user: Dictionary) -> int:
	var result := OK
	
	var new_session : NakamaSession = yield(
		_client.authenticate_device_async(user["device_id"]), "completed"
	)
	
	result = update_async_result(new_session, result)

	return result

func authenticate_async(email: String, password: String, register := false) -> int:
	var result := OK
	
	var new_session : NakamaSession = yield(
		_client.authenticate_email_async(email, password, null, register), "completed"
	)
	
	result = update_async_result(new_session, result)
	
	return result

func logout_async() -> void:	
# warning-ignore:return_value_discarded
	_client.session_logout_async(_session)

func update_async_result(session: NakamaSession, result: int) -> int:
	if not session.is_exception():
		_session = session
	else:
		result = session.get_exception().status_code
	
	return result

func is_linked_account(device_id) -> bool:
	if device_id != "":
		return false
	return true

func create_guest_linked_account(user: Dictionary) -> int:
	var error := FAILED
	
	var result : NakamaAsyncResult = yield(
		_client.link_custom_async(_session, user["id"]), "completed"
	)
	
	if not result.is_exception():
		error = unlink_device_id(user)
	
	return error

func unlink_device_id(user: Dictionary) -> int:
	var result := OK
	
	var new_session : NakamaSession = yield(
		_client.unlink_device_async(_session, user["device_id"]), "completed"
	)
	
	_session = new_session
	
	result = update_async_result(new_session, result)
	
	return result

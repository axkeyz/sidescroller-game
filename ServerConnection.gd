extends Node

const KEY := "axkeyz_sidescroller"

var _session : NakamaSession

var _client := Nakama.create_client(KEY, "127.0.0.1", 7350, "http")

func guest_login_async(username : String) -> int:
	var result := OK
	
	var new_session : NakamaSession = yield(
		_client.authenticate_device_async(OS.get_unique_id(), username), "completed"
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

func logout_async() -> int:
	var result := OK
	
	var new_session : NakamaSession = yield(
		_client.session_logout_async(_session), "completed"
	)
	
	result = update_async_result(new_session, result)
	
	return result

func update_async_result(session: NakamaSession, result: int) -> int:
	if not session.is_exception():
		_session = session
	else:
		result = session.get_exception().status_code
	
	return result

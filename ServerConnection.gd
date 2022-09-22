extends Node

const KEY := "axkeyz_sidescroller"

var _session : NakamaSession

var _client := Nakama.create_client(KEY, "127.0.0.1", 7350, "http")

func guest_login_async(username : String) -> int:
	var result := OK
	
	var new_session : NakamaSession = yield(
		_client.authenticate_device_async(OS.get_unique_id(), username), "completed"
	)
	
	if not new_session.is_exception():
		_session = new_session
	else:
		result = new_session.get_exception().status_code

	return result

func authenticate_async(email: String, password: String) -> int:
	var result := OK
	
	var new_session : NakamaSession = yield(
		_client.authenticate_email_async(email, password, null, false), "completed"
	)
	
	if not new_session.is_exception():
		_session = new_session
	else:
		result = new_session.get_exception().status_code
	
	return result

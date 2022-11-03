extends PopupPanel


# Declare member variables here. Examples:
onready var warning_label = $M/V/Start/V/WarningLabel

signal register_username

func _on_RegisterUsernameButton_pressed() -> void:
	var username = $M/V/InputFields/Username/M/UserInputText.text
	
	if not $M/V/TOS/TOSCheckbox.toggle_mode:
		warning_label.text = "You must agree to the terms and conditions."
	elif username.text == "":
		warning_label.text = "A username is required."
	elif Utils.has_punctuation(username):
		warning_label.text = "Username contains forbidden characters."
	else:
		emit_signal("register_username", username)

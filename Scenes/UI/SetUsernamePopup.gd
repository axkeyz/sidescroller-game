extends PopupPanel


# Declare member variables here. Examples:
signal register_username


func _on_RegisterUsernameButton_pressed() -> void:
	var username = $M/V/InputFields/Username/M/UserInputText.text
	
	if not $M/V/TOS/TOSCheckbox.toggle_mode:
		$M/V/Start/V/WarningLabel.text = "You must agree to the terms and conditions."
	elif $M/V/InputFields/Username/M/UserInputText.text == "":
		$M/V/Start/V/WarningLabel.text = "A username is required."
	else:
		emit_signal("register_username", username)

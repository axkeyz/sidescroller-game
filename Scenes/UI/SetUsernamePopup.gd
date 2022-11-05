extends PopupPanel


# Declare member variables here. Examples:
onready var warning_label = $M/V/Start/V/WarningLabel
var username : String = ""

signal register_username

func _ready() -> void:
	var error := $M/V/InputFields/Username/M/UserInputText.connect("text_changed", self, "on_update_username")
	Utils.print_error_code(error)

func on_update_username(new_text: String) -> void:
	username = new_text
	pass

func _on_RegisterUsernameButton_pressed() -> void:
	if not $M/V/Start/V/TOSCheckbox.pressed:
		warning_label.text = "You must agree to the terms and conditions."
	elif len(username) < 3 or len(username) > 12:
		warning_label.text = "Username must be between 3 to 12 characters."
	elif Utils.has_punctuation(username) or Utils.has_forbidden_words(username):
		warning_label.text = "Contains forbidden characters or words."
	else:
		warning_label.text = ""
		emit_signal("register_username", username)

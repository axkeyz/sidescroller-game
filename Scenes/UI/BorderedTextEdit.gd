extends Panel

## Placeholder text
export var placeholder := "LABEL"

## Is password input field -> bool
export var password := false

func _ready() -> void:
	$M/UserInputText.placeholder_text = placeholder.to_upper()
	$M/UserInputText.secret = password

func _on_BorderedTextEdit_gui_input(event) -> void:
	if event is InputEventScreenTouch:
		$M/UserInputText.grab_focus()

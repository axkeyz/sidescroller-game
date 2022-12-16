extends Control

func _on_ToggleButton_pressed() -> void:
	$C1.visible = ! $C1.visible

func _on_SettingsSlideOut_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.position.x < 1280 and $C1.visible:
			$C1.visible = false

extends Panel

#func _on_BorderedTextEdit_gui_input(event):
#	print("got here")
#	if event is InputEventScreenTouch:
#		$M/VBoxContainer/UserInputText.grab_focus()

#
#func _on_M_gui_input(event):
#	if event is InputEventScreenTouch:
#		$M/VBoxContainer/UserInputText.grab_focus()


func _on_BorderedTextEdit_gui_input(event):
	if event is InputEventScreenTouch:
		$M/VBoxContainer/UserInputText.grab_focus()
	pass # Replace with function body.

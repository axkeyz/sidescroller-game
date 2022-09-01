extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$HideLobbyTimer.start()

func _input(_event):
	show_LobbyUI()

func _on_HideLobbyTimer_timeout():
	var tween := Tween.new()
	add_child(tween)
	
# warning-ignore:return_value_discarded
	tween.interpolate_property($M, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5)
	tween.set_active(true)

	# Wait until tween ends, if necessary.
	yield(tween, "tween_completed")

	tween.queue_free()
	
	$M.hide()
	$M.modulate = Color(1,1,1,1)

func show_LobbyUI():
	$M.show()
	$HideLobbyTimer.start()

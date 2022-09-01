extends VBoxContainer


# Declare member variables here. Examples:
var img_x = 614
var new_swipe = false
var og_value = 0
var drag = Vector2()

onready var child_count = $BannerContainer/Banners.get_child_count()
onready var max_tab_index = child_count-1

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			# Get initial position of a swipe start
			drag.x = event.get_position().x
		else:
			# Get final x-coordinate of a swipe end and
			# subtract from the x-coordinate swipe start
			# to find the direction of swipe along x axis
			drag.y = event.get_position().x
			
			print(drag.y, " ", drag.x)
			
			if abs(drag.y-drag.x) > img_x:
				print("got here")

func _on_BannerContainer_scroll_started():
#	$BannerContainer.NOTIFICATION_SCROLL_END
	pass # Replace with function body.


func _on_BannerContainer_scroll_ended():
#	$BannerContainer.get_h_scrollbar().value = og_value
#	og_value = 0
#	new_swipe = false
#	$BannerContainer.set_mouse_filter(Control.MOUSE_FILTER_PASS)
	pass # Replace with function body.

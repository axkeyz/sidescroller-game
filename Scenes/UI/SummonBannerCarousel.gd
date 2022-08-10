extends VBoxContainer

var tab = 0
var max_tab_index
var drag_start
var drag

func _ready():
	# Set max index of tabs
	max_tab_index = $Tabs.get_tab_count()-1
	
func _on_Tabs_gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			# Get initial position of a swipe start
			drag_start = event.get_position().x
		else:
			# Get final x-coordinate of a swipe end and
			# subtract from the x-coordinate swipe start
			# to find the direction of swipe along x axis
			drag = event.get_position().x - drag_start
			on_active_tab_swiped()

# on_active_tab_swiped changes the currently active tab
# when the node is swiped.
func on_active_tab_swiped():
	if drag > 0:
		if tab == 0:
			tab = max_tab_index
		else:
			tab -= 1
	elif drag < 0:
		if tab == max_tab_index:
			tab = 0
		else:
			tab += 1

	$Tabs.current_tab = tab

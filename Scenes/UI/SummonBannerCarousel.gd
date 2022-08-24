# SummonBannerCarousel.gd controls the SummonBannerCarousel
# UI element in the Lobby scene.
# TODO: Use Tween to animate transitions more smoothly.
extends VBoxContainer

var current_tab = 0
var max_tab_index
var drag_start
var drag_x

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set max index of tabs
	max_tab_index = $BannerTabs.get_tab_count()-1
	
	# Add tabs to $BannerTabsList and set default value
	add_tab_to_BannerTabsList()
	reset_BannerTabs_current_tab()

# _on_BannerTabs_gui_input is called when a GUI input event 
# happens inside $BannerTabs. It changes the active tab to
# the adjacent tab in the direction of the user's swipe.
func _on_BannerTabs_gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			# Get initial position of a swipe start
			drag_start = event.get_position().x
		else:
			# Get final x-coordinate of a swipe end and
			# subtract from the x-coordinate swipe start
			# to find the direction of swipe along x axis
			drag_x = event.get_position().x - drag_start
			on_BannerTabs_swiped()

# on_BannerTabs_swiped is called when a swipe's beginning
# is found to be on the inside of $BannerTabs.
func on_BannerTabs_swiped():
	calculate_current_tab_from_swipe()
	reset_BannerTabs_current_tab()

# calculate_current_tab_from_swipe calcuates the value of var 
# tab based on var drag.
func calculate_current_tab_from_swipe():
	if drag_x > 0:
		# Get previous tab on drag to right
		if current_tab == 0:
			# Loop back to max tab
			current_tab = max_tab_index
		else:
			# Get previous tab
			current_tab -= 1
	# Drag to the left
	elif drag_x < 0:
		# Get next tab on drag to left
		if current_tab == max_tab_index:
			# Loop to min tab
			current_tab = 0
		else:
			# Get next tab
			current_tab += 1

# add_tab_to_BannerTabsList adds an option to $BannerTabsList
# for every banner saved in $BannerTabs.
func add_tab_to_BannerTabsList():
	# Load button scene
	var button = load("res://Scenes/UI/SummonBannerButton.tscn")
	
	# Create new summon banner button for each tab
	var count = $BannerTabs.get_child_count()
	for i in range(0, count):
		# Create new instance with signal
		var child = button.instance()
		child.connect("pressed", self, \
			"on_click_tab_in_BannerTabsList", [i])
		
		# Add instance to $BannerTabsList
		$BannerTabsList.add_child(child)

# on_click_tab_in_BannerTabsList changes the currently active
# banner.
func on_click_tab_in_BannerTabsList(id):
	current_tab = id
	reset_BannerTabs_current_tab()

# reset_BannerTabs_current_tab sets the currently active tab of
# $BannerTabs and simulates a click on the corresponding button
# (child node) in $BannerTabsList.
func reset_BannerTabs_current_tab():
	$BannerTabs.current_tab = current_tab
	$BannerTabsList.get_child(current_tab).grab_focus()
	$TabTimer.start()

# _on_TabTimer_timeout swipes to the next banner after $TabTimer
# has timed out.
func _on_TabTimer_timeout():
	drag_x = -20
	on_BannerTabs_swiped()

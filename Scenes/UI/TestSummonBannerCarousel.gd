extends VBoxContainer

const BUFFER = 50
const SCROLL_SPEED = 12

var prev_pos
var next_pos
var drag_start = 0
var drag_x

var prev_tab = 0
var next_tab = 0
var banner_x = 614

onready var tween = $BannerContainer/Tween
onready var child_count = $BannerContainer/Banners.get_child_count()
onready var max_tab_index = child_count-1
onready var box = $BannerContainer/Banners

func _ready():
	add_tab_to_BannerButtons()
	reset_BannerButtons_current_button()
	
	box.add_child(box.get_child(0).duplicate())
	
#	$BannerButtons.get_h_scrollbar().
#	box.add_child(box.get_child(max_tab_index).duplicate())
#	box.move_child

func get_drag_dir():
	if drag_x > 0:
		return -1
	else:
		return 1

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			# Get initial position of a swipe start
			drag_start = event.get_position().x
		else:
			# Get final x-coordinate of a swipe end and
			# subtract from the x-coordinate swipe start
			# to find the direction of swipe along x axis
			drag_x = event.get_position().x - drag_start
			
			#
			$BannerContainer.set_mouse_filter(Control.MOUSE_FILTER_PASS)
			
	if event is InputEventScreenDrag:
		if $BannerContainer.scroll_horizontal - banner_x*0.5 > banner_x*next_tab:
			$BannerContainer.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	
func _on_BannerContainer_scroll_ended():
	calculate_current_tab_from_swipe()
	change_banner()
	
	next_pos = prev_pos
	pass

func calculate_tab_from_drag():
	if drag_x > 0:
		# Get previous tab on drag to right
		next_tab -= 1
	# Drag to the left
	elif drag_x < 0:
		# Get next tab on drag to left
		next_tab += 1
		
func calculate_positions():
	prev_pos = $BannerContainer.scroll_horizontal
	next_pos = next_tab*banner_x

func calculate_current_tab_from_swipe():
	calculate_tab_from_drag()
	calculate_positions()

func change_banner():
	tween.interpolate_property($BannerContainer, 
		"scroll_horizontal", prev_pos, next_pos, 0.1,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	
	
func _on_Tween_tween_all_completed():
	if next_tab == child_count:
		# Set end tab as first tab
		$BannerContainer.scroll_horizontal = 0
		next_tab = 0
#	elif next_tab == 0:
#		box.move_child(box.get_child(max_tab_index), 0)
#		$BannerContainer.scroll_horizontal = banner_x
#		next_tab = max_tab_index

# add_tab_to_BannerContainer adds a button to $BannerButtons
# for every banner saved in $BannerContainer/Banners.
func add_tab_to_BannerButtons():
	# Load button scene
	var button = load("res://Scenes/UI/SummonBannerButton.tscn")

	# Create new summon banner button for each tab
	for i in range(0, child_count):
		# Create new instance with signal
		var child = button.instance()
		child.connect("pressed", self, 
			"on_click_button_in_BannerButtons", [i])

		# Add instance to $BannerTabsList
		$BannerButtons.add_child(child)
#
## on_click_button_in_BannerButtons changes the currently active
## banner when clicking the corresponding banner button.
#func on_click_button_in_BannerButtons(id):
#	next_tab = id
#	change_banner()

# reset_BannerTabs_current_tab sets the currently active tab of
# $BannerTabs and simulates a click on the corresponding button
# (child node) in $BannerTabsList.
func reset_BannerButtons_current_button():
	$BannerButtons.get_child(prev_tab).grab_focus()
#	$Timer.start()
#
func _on_Timer_timeout():
	pass
#	detect_next_tab()
#	change_banner()

#func detect_next_tab():
#	if next_tab == max_tab_index:
#		next_tab = 0
#	elif next_tab > max_tab_index:
#		prev_tab = 0
#	else:
#		next_tab += 1

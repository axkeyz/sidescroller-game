extends ScrollContainer

const BUFFER = 10 #not necessity but preference; could be removed or set to 0
const UPDATE_LENGTH = 1

var scroll_size = 0
const SCROLL_DELAY = 200
onready var last_scroll = OS.get_ticks_msec()
onready var box = get_node("Banners")
onready var box_children = box.get_child_count() - 1
onready var size_x = get_rect().size.x
onready var tween = $BannerContainer/Tween

var drag_start
var drag_x
var current_tab = 0
var next_pos
var prev_pos
var prev_tab = 0
var next_tab = 0

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
			change_banner()
			
	#if desired, add a check here that the swiping is on top of the control, that the control is not hidden, etc.; as coded, it will run anytime there is a drag anywhere on the screen (this happened to fit my usage case)
#	if event is InputEventScreenDrag:
#		if abs(event.relative.normalized().x) > abs(event.relative.normalized().y):
#			print(event.relative.x)
#			scroll_vertical += UPDATE_LENGTH * event.relative.x
#			if last_scroll < OS.get_ticks_msec() - SCROLL_DELAY:
#				last_scroll = OS.get_ticks_msec()
#				check_loop()

func check_loop():
	var scroll_size = get_v_scrollbar().max_value #not ideal to check each time, but always returns 100 when in _ready()
	if scroll_vertical + size_x >= scroll_size - BUFFER:
		box.move_child(box.get_child(0), box_children)
	elif scroll_vertical <= BUFFER:
		box.move_child(box.get_child(box_children), 0)
#	if drag_x > 0:
#		# Get previous tab on drag to right
#		if current_tab == 0:
#			# Loop back to max tab
#			box.move_child(box.get_child(0), box_children)
#	# Drag to the left
#	elif drag_x < 0:
#		# Get next tab on drag to left
#		if current_tab == max_tab_index:
#			# Loop to min tab
#			box.move_child(box.get_child(box_children), 0)

# calculate_current_tab_from_swipe calcuates the value of var 
# tab based on var drag.
#func calculate_current_tab_from_swipe():
#	if drag_x > 0:
#		# Get previous tab on drag to right
#		if current_tab == 0:
#			# Loop back to max tab
#			current_tab = max_tab_index
#		else:
#			# Get previous tab
#			current_tab -= 1
#	# Drag to the left
#	elif drag_x < 0:
#		# Get next tab on drag to left
#		if current_tab == max_tab_index:
#			# Loop to min tab
#			current_tab = 0
#		else:
#			# Get next tab
#			current_tab += 1

# change_banner scrolls $Banners to the next banner image
func change_banner():
	prev_pos = $BannerContainer.scroll_horizontal
	next_tab = int(round(float(prev_pos) / size_x))
	
	next_pos = next_tab*size_x
	print(prev_tab, next_tab, box_children)
	if prev_tab == box_children-1 and next_tab == 0:
		next_pos = next_tab*size_x
	elif prev_tab == 0 and next_tab == box_children-1:
		prev_pos = (next_tab+1)*size_x

	# Start animation from position to position
	tween.interpolate_property($BannerContainer, 
		"scroll_horizontal", prev_pos, next_pos, 0.1,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

	# Reset current highlighted buttons
	prev_tab = next_tab
	prev_pos = next_pos
#	reset_BannerButtons_current_button()

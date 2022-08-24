extends VBoxContainer

var prev_pos
var next_pos

var prev_tab = 0
var next_tab = 0
var banner_x = 614

onready var tween = $BannerContainer/Tween
onready var child_count = $BannerContainer/Banners.get_child_count()
onready var max_tab_index = child_count-1

func _ready():
	add_tab_to_BannerButtons()
	reset_BannerButtons_current_button()

func _on_BannerContainer_scroll_ended():
	prev_pos = $BannerContainer.scroll_horizontal
	next_tab = int(round(float(prev_pos) / banner_x))
	change_banner()

# change_banner scrolls $Banners to the next banner image
func change_banner():
	next_pos = next_tab*banner_x
	print(prev_tab, next_tab, child_count)
	if prev_tab == child_count-1 and next_tab == 0:
		next_pos = next_tab*banner_x
	elif prev_tab == 0 and next_tab == child_count-1:
		prev_pos = (next_tab+1)*banner_x
	
	# Start animation from position to position
	tween.interpolate_property($BannerContainer, 
		"scroll_horizontal", prev_pos, next_pos, 0.1,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	
	# Reset current highlighted buttons
	prev_tab = next_tab
	prev_pos = next_pos
	reset_BannerButtons_current_button()

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

# on_click_button_in_BannerButtons changes the currently active
# banner when clicking the corresponding banner button.
func on_click_button_in_BannerButtons(id):
	next_tab = id
	change_banner()

# reset_BannerTabs_current_tab sets the currently active tab of
# $BannerTabs and simulates a click on the corresponding button
# (child node) in $BannerTabsList.
func reset_BannerButtons_current_button():
	$BannerButtons.get_child(prev_tab).grab_focus()
	$Timer.start()

func _on_Timer_timeout():
	detect_next_tab()
	change_banner()

func detect_next_tab():
	if next_tab == max_tab_index:
		next_tab = 0
	elif next_tab > max_tab_index:
		prev_tab = 0
	else:
		next_tab += 1

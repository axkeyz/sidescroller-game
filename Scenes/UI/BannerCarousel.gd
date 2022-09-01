extends VBoxContainer

func _ready():
	add_button_to_ButtonContainer()

# add_button_to_ButtonContainer adds an option to $BannerTabsList
# for every banner saved in $BannerContainer.
func add_button_to_ButtonContainer():
	# Load button scene
	var button = load("res://Scenes/UI/SummonBannerButton.tscn")
	
	# Create new summon banner button for each tab
	var count = $BannerContainer.get_child_count() / 2
	for i in range(0, count):
		# Create new instance with signal
		var child = button.instance()
		child.connect("pressed", self, \
			"on_click_tab_in_BannerTabsList", [i])
		
		# Add instance to $BannerTabsList
		$ButtonContainer.add_child(child)

func on_click_button_in_ButtonContainer(tab):
	pass

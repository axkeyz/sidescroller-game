extends Container
class_name BannerCarousel


export var starting_angle := PI / 2
export var darkness := 0.2
export var transition_time := 0.6

onready var max_child_index = get_child_count() - 1

var tween: Tween
var queued_turns := []
var drag_x
var drag_start


func _ready() -> void:
	tween = Tween.new()
	add_child(tween)
# warning-ignore:return_value_discarded
	tween.connect("tween_all_completed", self, "on_tween_all_completed")
	for i in get_child_count() - 1:
		var c := get_child(i)
		fit_child_in_rect(c, Rect2(calculate_child_position(i), c.rect_size))
#	pass
	connect("gui_input", self, "_on_gui_input")

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			# Get initial position of a swipe start
			drag_start = event.get_position().x
		else:
			# Get final x-coordinate of a swipe end and
			# subtract from the x-coordinate swipe start
			# to find the direction of swipe along x axis
			drag_x = event.get_position().x - drag_start
		
			if drag_x > 0:
				move_to_left_banner()
			else:
				move_to_right_banner()
				print(get_children())

func move_to_right_banner() -> void:
	var arr := []
	for i in get_child_count() - 1:
		arr.append(null)
	for i in get_child_count() - 1:
		if not (get_child_count() - 1) % 2:
			if i == 0:
				arr[1] = get_child(i)
			elif i == get_child_count() - 2:
				arr[i - 1] = get_child(i)
			elif i % 2:
				arr[i + 2] = get_child(i)
			else:
				arr[i - 2] = get_child(i)
		else:
			if i == 0:
				arr[1] = get_child(i)
			elif i == get_child_count() - 3:
				arr[i + 1] = get_child(i)
			elif i % 2:
				arr[i + 2] = get_child(i)
			else:
				arr[i - 2] = get_child(i)
	arr.append(tween)
	for child in get_children():
		remove_child(child)
	for child in arr:
		add_child(child)
	
	tween_children()
	print("yes this function")
	pass


func move_to_left_banner() -> void:
	var arr := []
	for i in get_child_count() - 1:
		arr.append(null)
	for i in get_child_count() - 1:
		if not (get_child_count() - 1) % 2:
			if i == 1:
				arr[0] = get_child(i)
			elif i == get_child_count() - 3:
				arr[i + 1] = get_child(i)
			elif i % 2:
				arr[i - 2] = get_child(i)
			else:
				arr[i + 2] = get_child(i)
		else:
			if i == 1:
				arr[0] = get_child(i)
			elif i == get_child_count() - 2:
				arr[i - 1] = get_child(i)
			elif i % 2:
				arr[i - 2] = get_child(i)
			else:
				arr[i + 2] = get_child(i)
	arr.append(tween)
	for child in get_children():
		remove_child(child)
	for child in arr:
		add_child(child)

	tween_children()


func tween_children() -> void:
	for i in get_child_count() - 1:
		var c := get_child(i)
# warning-ignore:return_value_discarded
		tween.interpolate_property(c, "rect_position", c.rect_position, calculate_child_position(i), transition_time)
# warning-ignore:return_value_discarded
	tween.start()


func calculate_child_position(i: int) -> Vector2:
	var angle_sign := -1 if i % 2 else 1
	var spacing := PI / (get_child_count() - 1) * (get_child_count() - i - 2)
	var offset := PI / (get_child_count() - 1) / 2
	var angle := starting_angle + angle_sign * spacing

	if not get_child_count() == i + 2:
		if not (get_child_count() - 1) % 2:
			angle += offset
		else:
			angle -= offset

	if not (get_child_count() - 1) % 2 and i == 0:
		angle += offset
	
	var center := Vector2(cos(angle), 0) * rect_size / 2 + rect_size / 2
	var top_left: Vector2 = center - get_child(i).rect_size / 2

	return top_left

func on_tween_all_completed() -> void:
	if queued_turns:
		call(queued_turns.pop_front())

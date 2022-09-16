extends ParallaxBackground

export (float) var scrolling_speed = 120.0
export (bool) var is_scrolling = false

func _physics_process(delta):
	if is_scrolling:
		scroll_base_offset.x -= scrolling_speed * delta

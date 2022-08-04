extends ParallaxBackground

export (float) var scrolling_speed = 120.0

func _physics_process(delta):
	scroll_base_offset.x -= scrolling_speed * delta

extends ScrollContainer

var end_point: int
var start_point: int
var relative: int
onready var tween = get_node("Tween")

func _input(event):
	if event is InputEventScreenTouch:
		if not event.pressed:
			end_point = self.scroll_horizontal
			
			if relative <0 and relative <= -10: 
				start_point = end_point + relative * -10
			elif relative > 0 and relative >= 10:
				start_point = end_point - relative * 10
			else:
				start_point = end_point
				self.set_h_scroll(end_point)
			
			tween.interpolate_property(self,"scroll_horizontal",end_point,start_point,.3,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			tween.start()

	if event is InputEventScreenDrag:
		relative = event.relative.x

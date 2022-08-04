extends KinematicBody2D

var POS_Y = 950

func _ready():
	get_node("CombatSprite").position.y = POS_Y

func _physics_process(delta):
	move_x(delta)

func move_x(delta):
	var path_position = get_global_mouse_position()
	var path_position_x = Vector2(clamp(path_position.x, 120, 1800), POS_Y)
	# TODO: Clamp 1800 -> "safe" distance from enemy
	get_node("CombatSprite").position = get_node("CombatSprite").position.linear_interpolate(path_position_x, delta * 0.5)
#	get_node("CombatSprite").position.x = clamp(path_position.x, 120, 1800)
	pass

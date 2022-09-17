extends KinematicBody2D

export (int) var pos_y = 950
export (int) var safe_x = 80

var is_deployed = false

func _ready():
	get_node("CombatSprite").position.y = pos_y

func _physics_process(delta):
	if is_deployed:
		run(delta)

func run(delta):
	var path_position = get_global_mouse_position()
	var path_position_x = Vector2(clamp(path_position.x, 120, 1800), pos_y)
	# TODO: Clamp 1800 -> "safe" distance from enemy
	get_node("CombatSprite").position = get_node("CombatSprite").position.linear_interpolate(path_position_x, delta * 0.5)
#	get_node("CombatSprite").position.x = clamp(path_position.x, 120, 1800)
	pass

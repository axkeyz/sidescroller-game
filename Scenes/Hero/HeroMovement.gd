extends KinematicBody2D

export (int) var pos_y = 950
export (int) var safe_x = 80
export (int) var deploy_cost = 5
export (int) var hp = 20000

var is_deployed : bool = false

export (Dictionary) var stats = {
	"hp": 20000,
	"def": 1500,
	"atk": 1000,
	"crit": 15,
	"cdmg": 150,
	"eva": 20,
	"hit": 20,
	"aspd": 20,
	"cdr": 10,
	"ccres": 20,
	"cc": 0,
}

#signal hp_depleted
signal deploy_success

#func _ready():
#	connect("deploy_success", self, "set_pos_x", [])

#func _physics_process(delta: float):
#	if is_deployed:
#		run(delta)

func set_pos_x(pos_x : float) -> void:
	get_node("CombatSprite").position = Vector2(pos_x, pos_y)

func deploy(total_cost : float, pos_x : float) -> void:
	if total_cost >= deploy_cost:
		is_deployed = true
		set_pos_x(pos_x)
		emit_signal("deploy_success")
	else:
		is_deployed = false

func run(delta):
	var path_position = get_global_mouse_position()
	var path_position_x = Vector2(clamp(path_position.x, 120, 1800), pos_y)
	# TODO: Clamp 1800 -> "safe" distance from enemy
	get_node("CombatSprite").position = get_node("CombatSprite").position.linear_interpolate(path_position_x, delta * 0.5)
#	get_node("CombatSprite").position.x = clamp(path_position.x, 120, 1800)
	pass

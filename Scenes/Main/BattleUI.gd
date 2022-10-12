extends Control


# Declare member variables here. Examples:
var deploy_resources: int = 10
onready var max_deploy_resources: int = $V/HBoxContainer/DeployCostProgressBar.max_value
onready var deploy_timer := $V/HBoxContainer/DeployCostTimer
onready var deploy_cost_label := $V/HeaderContainer/DeployCostCountLabel
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$V/HeaderContainer/DeployCostCountLabel.text = String(deploy_resources)
	pass # Replace with function body.

func start_DeployResources(deploy_cost) -> void:
	if deploy_resources >= deploy_cost:
		deploy_resources -= deploy_cost
		deploy_timer.start()

func _on_DeployCostTimer_timeout() -> void:
	$V/HBoxContainer/DeployCostProgressBar.value += 1
	deploy_cost_label.text = String(deploy_resources)
	pass # Replace with function body.


func _on_DeployCostProgressBar_value_changed(value: float) -> void:
	if value >= max_deploy_resources and deploy_resources < 10:
		add_new_deploy_resource()
	if deploy_resources == 10:
		deploy_timer.stop()

func add_new_deploy_resource() -> void:
	deploy_resources += 1
	deploy_cost_label.text = String(deploy_resources)
	$V/HBoxContainer/DeployCostProgressBar.value = 0

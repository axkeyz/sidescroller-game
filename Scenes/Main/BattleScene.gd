extends Node2D


# Declare member variables here. Examples:


# Called when the node enters the scene tree for the first time.
func _ready():
	$Baxton.connect("deploy_success", self, "change_DeployResources")
	pass # Replace with function body.

func _on_DeployButton_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if not event.pressed:
			$Baxton.deploy($Baxton.deploy_cost, event.position.x)
	pass # Replace with function body.

func change_DeployResources():
	$Baxton.show()
	$BattleUI.start_DeployResources($Baxton.deploy_cost)

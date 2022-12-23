extends Node2D

# Declare member variables here.
## sets the default initial deployment resources
export (int) var initial_resources = 10
## sets the default ability to continuously increment resources over time
export (bool) var incrementing_resources = true
## sets the default max number of candidates per team in the battle
export (int) var max_candidates = 8
## sets the default acceptance  of external supporters from friends & guildies
export (bool) var allow_external_supporters = false
## sets the default max duration of a battle
export (int) var max_battle_duration = 180
## a sum of all enemies hp
var visible_candidates : int = 4
var sum_enemies_hp : int

signal game_over(success)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DurationTimer.wait_time = max_battle_duration
	
	# TODO: calculate sum_enemies_hp

func _process(_delta: float) -> void:
	if not $DurationTimer.is_stopped():
		check_game_over_status()

func _on_DurationTimer_timeout() -> void:
	check_game_over_status()

func check_game_over_status() -> void:
	if sum_enemies_hp == 0:
		emit_signal("game_over", true)
	else:
		emit_signal("game_over", false)

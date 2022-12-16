extends Control


# Declare member variables here. Examples:
export (int) var team_id = 0

var user := preload("res://Resources/User/UserDetails.tres")
var team

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_current_team_members()
	get_unlocked_teams()

func get_current_team_members() -> void:
	team = user.teams[team_id]
	for i in len(team):
		if team[i] != 0:
			var occupied_node := get_node("V/SetTeamH/TeamGrid/%d" % (i+1))
			occupied_node.color = Color( 1, 1, 1, 1 )

func get_unlocked_teams() -> void:
	var team_icons = load("res://Scenes/UI/TeamIcon.tscn")
	
	for i in len(user.teams):
		var team = team_icons.instance()
		
		if i == team_id:
			team.color = Color( 1, 1, 1, 1 )
		
		$V/ChangeTeamH/S/H.add_child(team)

# _on_CloseUIButton_pressed closes the SetTeamUI
func _on_CloseUIButton_pressed() -> void:
	self.queue_free()

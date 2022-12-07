extends HBoxContainer

var datetime
var date
var time

func _ready() -> void:
	update_date()
	update_datetime_label()

func _physics_process(_delta) -> void:
	update_datetime_label()
	
	$BatteryLabel.value = OS.get_power_percent_left()

func update_date() -> void:
	datetime = OS.get_datetime()
	
	date = "%02d/%02d/%04d" % [datetime["day"], datetime["month"],
	datetime["year"]]

func update_datetime_label() -> void:
	datetime = OS.get_time()
	
	time = "%02d:%02d" % [datetime["hour"], datetime["minute"]]
		
	$DateTimeLabel.text = date + " " + time

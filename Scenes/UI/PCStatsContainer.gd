extends HBoxContainer

var datetime
var date
var time

func _ready():
	update_date()
	update_datetime_label()

func _physics_process(_delta):
	update_datetime_label()
	
	$BatteryLabel.value = OS.get_power_percent_left()

func update_date():
	datetime = OS.get_datetime()
	
	date = "%02d/%02d/%04d" % [datetime["day"], datetime["month"],
	datetime["year"]]

func update_datetime_label():
	datetime = OS.get_time()
	
	time = "%02d:%02d" % [datetime["hour"], datetime["minute"]]
		
	$DateTimeLabel.text = date + " " + time

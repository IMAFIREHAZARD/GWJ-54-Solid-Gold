extends BoxContainer

export var bus = "Master"
var bus_index : int

enum States { IDLE, ACTIVE }
var State = States.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	bus_index = AudioServer.get_bus_index(bus)
	$Label.text = bus

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if State == States.ACTIVE:
		var desired_db = linear2db($VolumeSlider.value)
		AudioServer.set_bus_volume_db(bus_index, desired_db)



func _on_VolumeSlider_drag_started():
	State = States.ACTIVE
	$AudioStreamPlayer.play()

func _on_VolumeSlider_drag_ended(_value_changed):
	State = States.IDLE
	$AudioStreamPlayer.stop()
	

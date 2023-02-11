extends HBoxContainer


# Declare member variables here. Examples:
var elapsed_time : float = 0.0
var polling_interval : float = 0.1
var last_poll_time : float = 0.0

var actions = ["move_left", "move_right", "move_up", "move_down"]

enum States { IDLE, ACTIVE }
var State = States.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed_time += delta
	



func _on_HSlider_drag_started():
	State = States.ACTIVE



func _on_HSlider_value_changed(value):
	# fires every frame. Don't waste it.
	if elapsed_time > last_poll_time + polling_interval:
		for action in actions:
			InputMap.action_set_deadzone(action, $HSlider.value)


func _on_HSlider_drag_ended(value_changed):
	State = States.IDLE
#	for action in actions:
#		print(InputMap.action_get_deadzone(action))
#

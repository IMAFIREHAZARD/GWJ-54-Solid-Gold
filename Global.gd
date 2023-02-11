extends Node


var bpm : float = 90.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func is_paused():
	
	return get_tree().paused

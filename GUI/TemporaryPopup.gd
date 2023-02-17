extends Node2D


export var duration : float = 3.5

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.set_wait_time(duration)
	$Timer.start()
	



func _on_Timer_timeout():
	queue_free()

extends "res://GUI/GenericButton.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_GenericButton_pressed():
	$ClickNoise.start_persistant()
	var timer = get_tree().create_timer(0.35)
	yield(timer, "timeout")
	
	StageManager.quit()

extends KinematicBody2D


onready var area:Area2D = get_node("ClickArea")
onready var tween:Tween = get_node("Tween")
func _ready():
	pass # Replace with function body.

func moveTo(position_):
	
	tween.interpolate_property(self,"position",position,position_,1)
	tween.start()


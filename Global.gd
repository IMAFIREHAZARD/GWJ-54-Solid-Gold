extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

################## CREATED PROBLEMS IN AUDIOSYSTMES ###########################
################## probably not intended solution ############################
func is_paused():
	return get_tree().paused

var bpm = 1;
#########################################################################
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

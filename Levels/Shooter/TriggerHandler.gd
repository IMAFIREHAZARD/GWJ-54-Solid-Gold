extends Node

onready var level = StageManager.current_map

var lvlComplete = false

func _ready():
	pass # Replace with function body.

func evaluate():
	#print("TriggerHandler.gd - current_bugs == ", level.current_bugs)
	if level.current_bugs == 0:
		lvlComplete = true
		win()
	else:
		lvlComplete = false


func win():
	print("You Win")





#signals
func _on_Critters_child_exiting_tree(_node):
	evaluate()


func _on_Exit_body_entered(_body):
	if lvlComplete == true:
		print("exit stage")

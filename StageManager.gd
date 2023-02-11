"""
Autoload for managing scene transitions

"""

extends Control



func _ready():
	pass # Replace with function body.

func change_scene(ScenePath : String):
	# play some scene transition, then change scene
	get_tree().change_scene(ScenePath)
	
	
func change_scene_to(Scene : PackedScene):
	# play some scene transition, then change scene
	get_tree().change_scene_to(Scene)
	

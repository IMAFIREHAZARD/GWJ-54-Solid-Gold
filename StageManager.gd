"""
Autoload for managing scene transitions

"""

extends Control



func _ready():
	pass # Replace with function body.

func change_scene(ScenePath : String):
	var Scene = load(ScenePath)
	change_scene_to(Scene)
	
func change_scene_to(Scene : PackedScene):
	# play some scene transition, then change scene
	var fadeTransition = preload("res://Menus/SceneTransition.tscn").instance()
	add_child(fadeTransition)
	fadeTransition.fade_out()
	yield(fadeTransition, "FadedOut")
	get_tree().change_scene_to(Scene)
	fadeTransition.fade_in()
	yield(fadeTransition, "FadedIn")
	fadeTransition.queue_free()
	

"""
Autoload for managing scene transitions

"""

extends Control

var current_map
var current_packed_scene : PackedScene
var player
var hud

func _ready():
	
	current_packed_scene = load(get_tree().current_scene.filename)

func change_scene(ScenePath : String):
	var Scene = load(ScenePath)
	change_scene_to(Scene)

func restart_current_level():
	Global.reset_health()
	change_scene_to(current_packed_scene)
	
func change_scene_to(Scene : PackedScene):
	current_packed_scene = Scene
	# play some scene transition, then change scene
	var fadeTransition = preload("res://Menus/SceneTransition.tscn").instance()
	add_child(fadeTransition)
	fadeTransition.fade_out()
	yield(fadeTransition, "FadedOut")
	#warning-ignore:RETURN_VALUE_DISCARDED
	get_tree().change_scene_to(Scene)
	
	fadeTransition.fade_in()
	yield(fadeTransition, "FadedIn")
	fadeTransition.queue_free()
	
func quit():
	var fadeTransition = preload("res://Menus/SceneTransition.tscn").instance()
	add_child(fadeTransition)
	fadeTransition.fade_out()
	yield(fadeTransition, "FadedOut")
	get_tree().quit()
	

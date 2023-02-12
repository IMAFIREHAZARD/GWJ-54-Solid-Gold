extends "res://Entities/NPCs/BaseNPC.gd"
onready var debug_target: Polygon2D = $DebugTarget
onready var line_2d: Line2D = $Line2D

func _ready() -> void:
	randomize()
	debug_target.set_as_toplevel(true)
	goto_random_pos()

func _physics_process(delta: float) -> void:
	$Label.text = str(global_position.distance_to(nav_agent.get_next_location()))
	$Label.text += str(nav_agent.is_navigation_finished())

func _input(event: InputEvent) -> void:
	if event.is_action("shoot"):
		goto_random_pos()

func goto_random_pos() -> void:
	var targ = get_global_mouse_position()
	debug_target.global_position = targ
	go_to_location(targ)

func _on_NavigationAgent2D2_target_reached() -> void:
	print("We got there!")
	goto_random_pos()
	var extra_critter = duplicate()
	get_parent().add_child(extra_critter)


func _on_NavigationAgent2D2_navigation_finished() -> void:
	print("finished!")


func _on_NavigationAgent2D2_path_changed() -> void:
	print("path changed??")
	line_2d.clear_points()
	line_2d.points = nav_agent.get_nav_path()

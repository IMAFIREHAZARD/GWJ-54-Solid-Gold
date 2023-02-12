class_name Critter extends "res://Entities/NPCs/BaseNPC.gd"
onready var level = StageManager.current_map

func _ready() -> void:
	level.current_bugs += 1
	goto_random_pos()

func goto_random_pos() -> void:
	var targ = get_viewport_rect().size * Vector2(randf(), randf())
	go_to_location(targ)

func _on_NavigationAgent2D_navigation_finished() -> void:
	goto_random_pos()
	if level.current_bugs < level.max_bugs:
		if randi() % 3 == 0:
			var extra_critter = duplicate()
			get_parent().add_child(extra_critter)

func kill():
	level.current_bugs -= 1
	queue_free()

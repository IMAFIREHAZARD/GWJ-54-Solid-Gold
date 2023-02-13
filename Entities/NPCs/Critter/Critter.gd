class_name Critter extends "res://Entities/NPCs/BaseNPC.gd"
onready var level = StageManager.current_map
onready var animation_player: AnimationPlayer = $AnimationPlayer

export(PackedScene) var splat_scene

func _ready() -> void:
	level.current_bugs += 1
	goto_random_pos()

func goto_random_pos() -> void:
	var targ = get_viewport_rect().size * Vector2(randf(), randf()) * 2.5
	go_to_location(targ)

func _on_NavigationAgent2D_navigation_finished() -> void:
	if level.current_bugs < level.max_bugs:
		if randi() % 3 == 0:
			animation_player.play("Wiggle")
			yield(animation_player, "animation_finished")
			var extra_critter = duplicate()
			get_parent().add_child(extra_critter)
	goto_random_pos()
	

func kill():
	level.current_bugs -= 1
	queue_free()
	var splat = splat_scene.instance()
	get_parent().add_child(splat)
	splat.global_position = global_position

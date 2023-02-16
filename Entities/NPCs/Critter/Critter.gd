class_name Critter extends "res://Entities/NPCs/BaseNPC.gd"
onready var level = StageManager.current_map
onready var animation_player: AnimationPlayer = $AnimationPlayer

export(PackedScene) var splat_scene

func _ready() -> void:
	if level != null and level.get("current_bugs") != null:
		level.current_bugs += 1
	goto_random_pos()

func goto_random_pos() -> void:
	var targ = get_viewport_rect().size * Vector2(randf(), randf()) * 2.5
	go_to_location(targ)

func _on_NavigationAgent2D_navigation_finished() -> void:
	if level == null:
		return
		
	if level.current_bugs < level.max_bugs:
		if randi() % 3 == 0:
			animation_player.play("Wiggle")
			yield(animation_player, "animation_finished")
			var extra_critter = duplicate()
			get_parent().add_child(extra_critter)
	goto_random_pos()
	

func kill():
	if level != null:
		level.current_bugs -= 1
	$AnimationPlayer.play("hit")
	play_death_sound()
	# see also: _on_AnimationPlayer_animation_finished()


func leave_splat():
	var splat = splat_scene.instance()
	get_parent().call_deferred("add_child", splat)
	splat.global_position = global_position
	splat.global_scale = Vector2(5,5)

func play_death_sound():
	var sounds = $Audio.get_children()
	var randSound = sounds[randi()%sounds.size()]
	randSound.start_persistant()
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hit":
		leave_splat()
		call_deferred("queue_free")

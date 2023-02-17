class_name Critter extends Area2D
onready var level = StageManager.current_map
onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
onready var animation_player: AnimationPlayer = $AnimationPlayer
var targets : Array

export(PackedScene) var splat_scene

export var move_speed := 200

enum State {
	ROAM,
	TRACK_PLAYER,
	ATTACKING,
	DEAD,
	PAUSED
}
var state = State.ROAM

signal died

func _ready() -> void:
	for target in get_tree().get_nodes_in_group("BugTargets"):
		targets.append(target.global_position)
	if level != null and level.get("current_bugs") != null:
		level.current_bugs += 1
	goto_random_pos()
	


func goto_random_pos() -> void:
	var target = Vector2(randf(), randf())* 200
	if targets:
		target = targets[randi() % targets.size()]
	nav_agent.set_target_location(target)


func goto_player() -> void:
	nav_agent.set_target_location(StageManager.player.global_position)

func _physics_process(delta : float):
	if state in [State.ROAM, State.TRACK_PLAYER]:
		if not nav_agent.is_navigation_finished():
			global_position = global_position.move_toward(nav_agent.get_next_location(), move_speed*delta)


func _on_NavigationAgent2D_navigation_finished() -> void:
	if state == State.ROAM:
		# 1 in 3 change of duplicating
		if level.current_bugs < level.max_bugs and randi() % 3 == 0:
			state = State.PAUSED
			animation_player.play("Wiggle")
			yield(animation_player, "animation_finished")
			if state == State.DEAD: return
			var extra_critter = duplicate()
			get_parent().add_child(extra_critter)
			state = State.ROAM
		# 1 in 5 chance of hunting down the player
		elif randi() % 5 == 0:
			state = State.TRACK_PLAYER
			goto_player()
			return
		goto_random_pos()
	elif state == State.TRACK_PLAYER:
		goto_player()
	
	
	if level == null:
		return


func kill():
	if state == State.DEAD: return
	state = State.DEAD
	monitoring = false
	set_deferred("monitorable", false)
	if level != null:
		level.current_bugs -= 1
		connect("died", StageManager.hud, "_on_bug_died")
		emit_signal("died")
	$AnimationPlayer.play("hit")
	play_death_sound()
	# see also: _on_AnimationPlayer_animation_finished()


func leave_splat():
	var splat = splat_scene.instance()
	get_parent().add_child(splat)
	splat.global_position = global_position

func play_death_sound():
	var sounds = $Audio.get_children()
	var randSound = sounds[randi()%sounds.size()]
	randSound.start_persistant()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hit":
		leave_splat()
		call_deferred("queue_free")


func _on_AttackArea_body_entered(body: Node2D) -> void:
	if state in [State.TRACK_PLAYER, State.ROAM]:
		state = State.ATTACKING
		var start_pos = global_position
		var player_pos = body.global_position
		var tween = create_tween()
		tween.tween_interval(0.5)
		tween.tween_property(self, "global_position", player_pos, 0.2)
		tween.tween_property(self, "global_position", start_pos, 0.2)
		yield(tween,"finished")
		if state == State.DEAD: return
		state = State.ROAM
		goto_random_pos()

# hit player
func _on_Critter_body_entered(body: Node) -> void:
	if body == StageManager.player:
		body._on_hit(1)

class_name Critter extends Area2D
onready var level = StageManager.current_map
onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
onready var animation_player: AnimationPlayer = $AnimationPlayer
var targets : Array
var velocity : Vector2

export(PackedScene) var splat_scene

export var move_speed : float = 250.0
export var knockback_speed : float = 2500.0
export var random_start_location : bool = true

enum State {
	ROAM,
	TRACK_PLAYER,
	ATTACKING,
	DYING,
	DEAD,
	PAUSED
}
var state = State.ROAM
var previous_state = state

signal died

func _ready() -> void:
	velocity = Vector2.RIGHT.rotated(randf()*TAU)

	for target in get_tree().get_nodes_in_group("BugTargets"):
		targets.append(target.global_position)
	if level != null and level.get("current_bugs") != null:
		level.current_bugs += 1
	
	#if random_start_location:
	
	set_random_navPos()
	
func pause():
	if state != State.PAUSED:
		previous_state = state
		state = State.PAUSED

func resume():
	state = previous_state

func set_random_navPos() -> void:
	var target = Vector2(randf(), randf())* 200
	if targets:
		target = targets[randi() % targets.size()]
	nav_agent.set_target_location(target)


func goto_player() -> void:
	nav_agent.set_target_location(StageManager.player.global_position)

func _physics_process(delta : float):
	if state in [State.ROAM, State.TRACK_PLAYER]:
		if not nav_agent.is_navigation_finished():
			var navigationVector = global_position.direction_to(nav_agent.get_next_location())
			var flockingVector = get_flocking_vector()
			velocity = navigationVector + flockingVector
			global_position += velocity.normalized() * move_speed * delta
	elif state in [ State.DYING ]: # knockback
		global_position += velocity.normalized() * knockback_speed * delta 


func get_flocking_vector():
	var cutoff_distance = 200.0
	var critters = get_tree().get_nodes_in_group("critters")
	var nearby_critters = []
	for critter in critters:
		if critter.get_global_position().distance_squared_to(global_position) < cutoff_distance * cutoff_distance:
			nearby_critters.push_back(critter)
	
	var avoidance_vector = Vector2.ZERO
	var avoidance_distance = 60.0
	var collision_count = 0.0
	for critter in nearby_critters:
		if critter.get_global_position().distance_squared_to(global_position) < avoidance_distance * avoidance_distance:
			avoidance_vector += global_position - critter.global_position
			collision_count += 1.0
	if collision_count > 0:
		avoidance_vector /= 	collision_count
	
	var cohesion_vector = Vector2.ZERO
	for critter in nearby_critters:
		cohesion_vector += critter.global_position - global_position
	cohesion_vector /= nearby_critters.size()
	
	var alignment_vector = Vector2.ZERO
	for critter in nearby_critters:
		alignment_vector += critter.velocity
	alignment_vector /= nearby_critters.size()

	return ( avoidance_vector.normalized() + 0.5 * cohesion_vector.normalized() + alignment_vector.normalized()).normalized()
	
			
func reproduce():
	animation_player.play("Wiggle")

	return # wasn't clear to the player why the critter count is going up.
	
	state = State.PAUSED
	
	yield(animation_player, "animation_finished")
	if state == State.DEAD: return
	var extra_critter = duplicate()
	get_parent().add_child(extra_critter)
	state = State.ROAM


func _on_NavigationAgent2D_navigation_finished() -> void:
	choose_new_behaviour()


func choose_new_behaviour():
	if state == State.ROAM:
		if level.current_bugs < level.max_bugs and randf() < 0.0: # never ever
			reproduce()
		elif randf() < 1.0 and !Dialogic.has_current_dialog_node(): # always
			state = State.TRACK_PLAYER
			goto_player()
			return
		
		set_random_navPos()
	elif state == State.TRACK_PLAYER:
		goto_player()
	
	
	if level == null:
		return

func knockback(impactVector):
	state = State.DYING
	velocity = impactVector
	$KnockbackTimer.start()


func kill():
	if state == State.DEAD: return
	state = State.DEAD
	monitoring = false
	set_deferred("monitorable", false)
	if level != null:
		level.current_bugs -= 1
		#warning-ignore:RETURN_VALUE_DISCARDED
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
	if Dialogic.has_current_dialog_node():
		return

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
		set_random_navPos()

# hit player
func _on_Critter_body_entered(body: Node) -> void:
	if Dialogic.has_current_dialog_node():
		return
	
	if body == StageManager.player:
		body._on_hit(1)


func _on_NavUpdateTimer_timeout():
	pass # Replace with function body.


func _on_hit(impactVector : Vector2 = Vector2.ZERO):
	if impactVector == Vector2.ZERO:
		impactVector = global_position.direction_to(StageManager.player.global_position)
	knockback(impactVector)

func _on_KnockbackTimer_timeout():
	kill()

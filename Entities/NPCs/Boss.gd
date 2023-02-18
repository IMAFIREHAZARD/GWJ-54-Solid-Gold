extends Sprite

export(PackedScene) var summon_attack_scene
export(PackedScene) var projectile_scene
export(PackedScene) var slow_attack_scene
const attacks = ["do_summon_attack", "do_curse_attack", "do_projectile_attack"]

var attack_index = 0
var health_max : float = 100.0
var health := health_max
var crack_threshold : float = 10 # how much damage to get one crack
var num_cracks : int = 0

enum States { READY, ATTACKING, DYING, DEAD }
var State = States.READY

func do_next_attack():
	if State in [States.DYING, States.DEAD]:
		return
	
	attack_index += 1
	attack_index %= attacks.size()

	if attacks[attack_index] != "do_projectile_attack": # moved into animation player node for timing
		call(attacks[attack_index])
	if $AnimationPlayer.has_animation(attacks[attack_index]):
		$AnimationPlayer.play(attacks[attack_index])


func do_summon_attack():
	for attack_pos in $SummonAttackPositions.get_children():
		var attack = summon_attack_scene.instance()
		find_parent("YSort").add_child(attack)
		attack.global_position = attack_pos.global_position
		yield(get_tree().create_timer(0.3), "timeout")

func do_projectile_attack():
	var emitter = $Visuals/Left_Arm/ForearmRight/HandRight/do_projectile_attack
	for phi in [-0.2, -0.1, 0, 0.1, 0.2]:
		var attack_dir = emitter.global_position.direction_to(StageManager.player.global_position)
		attack_dir = attack_dir.rotated(phi)
		var proj = projectile_scene.instance()
		proj.travel_dir = attack_dir
		find_parent("YSort").add_child(proj)
		proj.global_position = emitter.global_position

func do_curse_attack():
	for attack_pos in $SummonAttackPositions.get_children():
		var attack = slow_attack_scene.instance()
		if find_parent("YSort"):
			find_parent("YSort").add_child(attack)
		else:
			get_tree().get_root().add_child(attack)
		attack.global_position = attack_pos.global_position
		yield(get_tree().create_timer(0.3), "timeout")

func _on_hit(damage):
	if State in [States.DYING, States.DEAD]:
		return
		
	elif damage > 0:
		health -= damage
		print("Boss health remaining " + str(health) + " out of " + str(health_max))
		if (health_max - health) / crack_threshold > num_cracks:
			find_node("CrackDecals").spawn_crack()
			$CrackNoises.play_random_noise()
			num_cracks += 1
	if health <= 0:
		die_horribly()
		
func die_horribly():
	$AttackTimer.stop()
	State = States.DYING
	$AnimationPlayer.play("die")

func spawn_dialog(timeline_name):
	var new_dialog = Dialogic.start('DefeatedBoss')
	add_child(new_dialog)
	new_dialog.connect("dialogic_signal", self, "_on_dialogic_signal")
	new_dialog.connect("timeline_end", self, "_on_dialogic_timeline_end")

func _on_dialogic_signal(params):
	pass

func _on_dialogic_timeline_end(timeline_name):
	if timeline_name == "BossDefeated":
		StageManager.change_scene("res://Menus/Credits.tscn")
	

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "die":
		State = States.DEAD
		print("Boss is Dead. Now what?")
		spawn_dialog("DefeatedBoss") # this should probably go in the current_map instead. 


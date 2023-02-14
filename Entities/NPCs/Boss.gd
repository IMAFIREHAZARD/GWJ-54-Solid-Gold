extends Sprite

export(PackedScene) var summon_attack_scene
export(PackedScene) var projectile_scene
const attacks = ["do_summon_attack", "do_projectile_attack", "do_curse_attack"]

var attack_index = 0

func do_next_attack():
	attack_index += 1
	attack_index %= attacks.size()
	call(attacks[attack_index])

func do_summon_attack():
	for attack_pos in $SummonAttackPositions.get_children():
		var attack = summon_attack_scene.instance()
		find_parent("BossRoot").get_parent().add_child(attack)
		attack.global_position = attack_pos.global_position
		yield(get_tree().create_timer(0.3), "timeout")

func do_projectile_attack():
	for phi in [-0.2, -0.1, 0, 0.1, 0.2]:
		var attack_dir = global_position.direction_to(StageManager.player.global_position)
		attack_dir = attack_dir.rotated(phi)
		var proj = projectile_scene.instance()
		proj.travel_dir = attack_dir
		find_parent("BossRoot").get_parent().add_child(proj)
		proj.global_position = global_position

func do_curse_attack():
	pass

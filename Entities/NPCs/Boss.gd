extends Sprite

export(PackedScene) var summon_attack_scene

func do_summon_attack():
	for attack_pos in $SummonAttackPositions.get_children():
		var attack = summon_attack_scene.instance()
		find_parent("BossRoot").get_parent().add_child(attack)
		attack.global_position = attack_pos.global_position
		yield(get_tree().create_timer(0.3), "timeout")

class_name SlowAttack extends Area2D
export var speed_mulitplier = 0.3

signal stun

func _on_BurstDelay_timeout() -> void:
	$AnimationPlayer.play("Burst")
	if overlaps_body(StageManager.player):
		#StageManager.player.stun(2)
		var impactVector = (global_position - StageManager.player.global_position).normalized()
		var impactMagnitude = 20.0
		
		if not is_connected("stun", StageManager.player, "_on_stun_attack_hit"):
			connect("stun", StageManager.player, "_on_stun_attack_hit")
		emit_signal("stun", impactVector)
		#StageManager.player.knockback(impactVector * impactMagnitude)
	#yield($AnimationPlayer, "animation_finished")
	#queue_free()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Warn":
		$AnimationPlayer.play("Slow")
		$BurstDelay.start()
	elif anim_name == "Burst":
		queue_free()

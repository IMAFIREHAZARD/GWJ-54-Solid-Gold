class_name SlowAttack extends Area2D
export var speed_mulitplier = 0.3

func _on_BurstDelay_timeout() -> void:
	$AnimationPlayer.play("Burst")
	if overlaps_body(StageManager.player):
		StageManager.player.stun(2)
	yield($AnimationPlayer, "animation_finished")
	queue_free()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Warn":
		$AnimationPlayer.play("Slow")
		$BurstDelay.start()

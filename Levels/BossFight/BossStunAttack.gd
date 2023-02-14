extends Area2D

var slowing = false

func _on_BurstDelay_timeout() -> void:
	$AnimationPlayer.play("Burst")
	if StageManager.player in get_overlapping_bodies():
		pass
		#TODO stun player
	yield($AnimationPlayer, "animation_finished")
	queue_free()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Warn":
		$AnimationPlayer.play("Slow")
		$BurstDelay.start()
		slowing = true

func _physics_process(delta: float) -> void:
	if slowing and StageManager.player in get_overlapping_bodies():
		pass
		#TODO slow player

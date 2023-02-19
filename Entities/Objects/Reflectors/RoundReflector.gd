extends Area2D

export var player_seeking_bias = 0.5

func _on_Reflector_area_entered(bullet: Area2D) -> void:
	var travel_dir = bullet.global_transform.x
	var normal = global_position.direction_to(bullet.global_position).tangent()
	var dir_to_player = bullet.global_position.direction_to(StageManager.player.global_position)
	travel_dir = travel_dir.reflect(normal.normalized()).slerp(dir_to_player.normalized(), player_seeking_bias)

	bullet.global_rotation = travel_dir.angle()
	bullet.set_collision_mask_bit(0, true)

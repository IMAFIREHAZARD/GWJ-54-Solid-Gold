extends Node2D
onready var ray_cast_2d: RayCast2D = $RayCast2D

export var speed = 1000

func _physics_process(delta: float) -> void:
	ray_cast_2d.cast_to = Vector2(-speed * delta, 0)
	ray_cast_2d.force_raycast_update()
	if ray_cast_2d.is_colliding():
		var bounced = false
		var collider = ray_cast_2d.get_collider()
		if "can_break" in collider:
			if collider.can_break:
				collider.break()
			else:
				pass
				# bounce
		if not bounced:
			queue_free()
	global_position += transform.x * speed * delta

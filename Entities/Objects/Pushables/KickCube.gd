extends StaticBody2D

onready var player : KinematicBody2D = StageManager.player
onready var ray_cast: RayCast2D = $RayCast2D
const directions = [ Vector2(2, 1), Vector2(2, -1), Vector2(-2, -1), Vector2(-2, 1)]
var moving = false


func _on_ClickArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("shoot") and not moving:
		if modulate != Color.aquamarine: return
		get_tree().set_input_as_handled()
		var raw_push_dir = player.global_position.direction_to(global_position)
		var dist = INF
		var snapped_push_dir : Vector2
		for dir in directions:
			dir = dir.normalized()
			var d = raw_push_dir.distance_to(dir)
			if d < dist:
				dist = d
				snapped_push_dir = dir
		var move_dist = sqrt(32*32+64*64)/2
		ray_cast.cast_to = snapped_push_dir * move_dist
		ray_cast.force_raycast_update()
		if not ray_cast.is_colliding():
			moving = true
			var tween = create_tween()
			tween.tween_property(self, "position", position + snapped_push_dir * move_dist, 0.3)
			yield(tween, "finished")
			moving = false


func _on_ClickArea_mouse_entered() -> void:
	if player.global_position.distance_to(global_position) < 80:
		modulate = Color.aquamarine


func _on_ClickArea_mouse_exited() -> void:
	modulate = Color.white

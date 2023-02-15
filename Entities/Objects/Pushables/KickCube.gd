class_name SokobanBlock extends KinematicBody2D

onready var player : KinematicBody2D = StageManager.player
onready var level = StageManager.current_map
onready var ray_cast: RayCast2D = $RayCast2D
onready var arrow: Polygon2D = $Arrow
const directions = [ Vector2(2, 1), Vector2(2, -1), Vector2(-2, -1), Vector2(-2, 1)]
const move_dist = 35.7771
var moving = false
var hovered = false
var push_dir : Vector2

func _on_ClickArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("shoot") and not moving:
		if modulate != Color.aquamarine: return
		ray_cast.cast_to = push_dir * move_dist
		ray_cast.force_raycast_update()
		
		if Global.strength_curse_taken:
			explode_into_smithereens()
		elif not ray_cast.is_colliding():
				moving = true
				var tween = create_tween()
				tween.tween_property(self, "position", position + push_dir * move_dist, 0.3)
				yield(tween, "finished")
				moving = false

func explode_into_smithereens():
	print("Player is very strong, box exploded.")
	queue_free()

func _physics_process(_delta: float) -> void:
	if hovered:
		if player in $PlayerArea.get_overlapping_bodies()\
		and level.hovered_block == null:
			level.hovered_block = self
			modulate = Color.aquamarine
			update_push_dir()
			arrow.show()
		else:
			modulate = Color.white
			arrow.hide()

func update_push_dir():
	
	var raw_push_dir = (player.global_position + Vector2(0, 16)).direction_to(global_position)
	var dist = INF
	for dir in directions:
		dir = dir.normalized()
		var d = raw_push_dir.distance_to(dir)
		if d < dist:
			dist = d
			push_dir = dir
	arrow.rotation = push_dir.angle()
	

func _on_ClickArea_mouse_entered() -> void:
	hovered = true


func _on_ClickArea_mouse_exited() -> void:
	hovered = false
	modulate = Color.white
	arrow.hide()

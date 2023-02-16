class_name PushBlock extends KinematicBody2D

onready var player : KinematicBody2D = StageManager.player
onready var level = StageManager.current_map
onready var ray_cast: RayCast2D = $RayCast2D
onready var arrow: Polygon2D = $Arrow
const directions = [ Vector2(2, 1), Vector2(2, -1), Vector2(-2, -1), Vector2(-2, 1)]
var move_dist = Vector2(32,64).length()/2
var moving = false
var is_highlighted = false
var hovered = true
var push_dir : Vector2

export var num_critters : int = 0
export var critter_scene : PackedScene
export var fragile : bool = false # fragile boxes should explode when bullets hit them


func _on_ClickArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("shoot") and not moving\
	and is_highlighted:
		ray_cast.cast_to = push_dir * move_dist
		
		var num_tiles = 1
		if Global.curses_taken["strength"]:
			num_tiles = 2
		for i in num_tiles:
			ray_cast.force_raycast_update()
			if ray_cast.is_colliding():
				if Global.curses_taken["strength"]:
					explode_into_smithereens()
					break
			else:
				moving = true
				play_audio()
				var tween = create_tween()
				tween.tween_property(self, "position", position + push_dir * move_dist * scale, 0.5 / num_tiles)
				yield(tween, "finished")
		
		moving = false
		stop_audio()

func play_audio():
	for noise in $PushAudio.get_children():
		noise.set_pitch_scale(rand_range(0.95,1.05))
		noise.play()

func stop_audio():
	for noise in $PushAudio.get_children():
		noise.stop()

func explode_into_smithereens():
	#print("Player is very strong, box exploded.")
	
	var noises = $ExplosionAudio.get_children()
	var randNoise = noises[randi()%noises.size()]
	randNoise.start_persistent()

	if num_critters > 0:
		spawn_critters()
	
	if has_node("AnimationPlayer") and $AnimationPlayer.has_animation("explode"):
		$AnimationPlayer.play("explode")
	else:
		queue_free()

func spawn_critters():
	for i in range(num_critters):
		var newCritter = critter_scene.instance()
		#newCritter.set_global_position(global_position)
		get_parent().call_deferred("add_child", newCritter)
		newCritter.set_global_position(global_position)


func _physics_process(_delta: float) -> void:
	if SokobanSelector.front_hovered_block == self:
		if is_player_near():
			set_highlighted(true)
			update_push_dir()
		else:
			set_highlighted(false)
#		and level.hovered_block == null:
#			level.hovered_block = self
#			modulate = Color.aquamarine
#			update_push_dir()
#			arrow.show()
#		else:
#			modulate = Color.white
#			arrow.hide()


func update_push_dir():
	#var feet_to_hands = Vector2.UP * 25.0 * player.global_scale # measured from player.tscn	
	var raw_push_dir = (player.global_position ).direction_to(global_position)
	var dist = INF
	for dir in directions:
		dir = dir.normalized()
		var d = raw_push_dir.distance_to(dir)
		if d < dist:
			dist = d
			push_dir = dir
	arrow.rotation = push_dir.angle()
	

func _on_ClickArea_mouse_entered() -> void:
	SokobanSelector.hovered_blocks.append(self)


func _on_ClickArea_mouse_exited() -> void:
	print("mouse is gone mate")
	SokobanSelector.hovered_blocks.erase(self)
	set_highlighted(false)


func is_player_near() -> bool:
	return $PlayerArea.overlaps_body(player)


func set_highlighted(highlight : bool) -> void:
	is_highlighted = highlight
	if highlight:
		modulate = Color.aquamarine
		arrow.show()
	else:
		modulate = Color.white
		arrow.hide()

func _exit_tree() -> void:
	if self in SokobanSelector.hovered_blocks:
		SokobanSelector.hovered_blocks.erase(self)

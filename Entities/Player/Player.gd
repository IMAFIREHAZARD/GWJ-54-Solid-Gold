extends KinematicBody2D

export var base_move_speed : float = 650.0
var move_speed := base_move_speed
onready var animated_sprite: AnimatedSprite = $SpriteRoot/AnimatedSprite
onready var reload_timer: Timer = $ReloadTimer

export(PackedScene) var bullet_scene
export(SpriteFrames) var default_frames
export(SpriteFrames) var gun_hands_frames
export(bool) var debug_start_with_machine_gun = false

var vel := Vector2()
var last_direction : Vector2 = Vector2.ZERO

var health : int = 3
var gravity : float = 9.8
export var levitate : bool = false


const idle_anim_names = [
	"IdleSouth",
	"IdleSW",
	"IdleWest",
	"IdleNW",
	"IdleNorth"
]

const run_anim_names = [
	"RunSouth",
	"RunSW",
	"RunWest",
	"RunNW",
	"RunNorth"
]
var dir_index = 0

enum States { READY, PUSHING_BLOCK, PAUSED, FALLING, DEAD, STUNNED }
var State = States.READY


func _enter_tree() -> void:
	StageManager.player = self

func _ready() -> void:
	#Dialogic.has_current_dialog_node()
	if Global.gun_curse_taken or debug_start_with_machine_gun:
		start_gun_curse()
	if Global.speed_curse_taken:
		move_speed += base_move_speed * 0.5
	print("player speed = " , move_speed)
	

func _physics_process(delta : float):
	$Debug/StateLabel.text = States.keys()[State]
	if State == States.READY:
		move_normally(delta)
	elif State == States.PUSHING_BLOCK:
		pass # let the customAffordance move you?
	elif State == States.FALLING:
		fall(delta)

func move_normally(delta : float):
	var move = Vector2()
	if !Dialogic.has_current_dialog_node():
		move = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		#move = move.rotated(PI/4.0) # isometric?
	var target_vel = move.normalized() * move_speed
	vel = vel.linear_interpolate(target_vel, delta * 30)
	# warning-ignore:return_value_discarded
	for zone in get_tree().get_nodes_in_group("SlowZones"):
		zone = zone as SlowAttack
		if zone.overlaps_body(self):
			vel *= zone.speed_mulitplier
	
	move_and_slide(vel * Vector2(1,0.5))
	animate_movement(vel)

	if StageManager.current_map != null and StageManager.current_map.has_method("get_tile_underneath"):
		if StageManager.current_map.get_tile_underneath(global_position) == "Void":
			fall_off_map()

	
func fall(delta : float):
	vel += Vector2.DOWN * gravity * delta
	position += vel
	if is_outside_frustum():
		begin_dying()

func is_outside_frustum():
	var screen_size = get_viewport_rect().size
	var my_position = global_position
	if my_position.x < 0 or my_position.x > screen_size.x or my_position.y < 0 or my_position.y > screen_size.y:
		return true
	else:
		return false


func animate_movement(directionVector):
	var anim_array
	var idle_speed_threshold = 50.0
	if (directionVector.length_squared() > idle_speed_threshold * idle_speed_threshold):
		anim_array = run_anim_names
		dir_index = round(Vector2.DOWN.angle_to(vel)/deg2rad(45))
		last_direction = directionVector
	else:
		anim_array = idle_anim_names
	
	
	animated_sprite.animation = anim_array[abs(dir_index)]
	if dir_index > 0:
		$SpriteRoot.scale.x = 1
	else:
		$SpriteRoot.scale.x = -1

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		if reload_timer.is_stopped():
			shoot()
			var tween = create_tween()
			var p = $TextureProgress
			p.show()
			p.value = 0
			tween.tween_property(p, "value", 1.0, reload_timer.wait_time)
			tween.tween_callback(p, "hide")

func has_affordance(affordanceName : String):
	if $CustomAffordances.get_node(affordanceName) != null:
		return true
	else:
		return false

func get_affordance(affordanceName : String):
	if has_affordance(affordanceName):
		return $CustomAffordances.get_node(affordanceName)
	

func shoot():
	reload_timer.start()
	var bullet = bullet_scene.instance() as Node2D
	get_parent().add_child(bullet)
	bullet.global_position = $BulletSpawnPoint.global_position
	bullet.rotation = bullet.get_local_mouse_position().angle() + rand_range(-0.1, 0.1)

func start_gun_curse():
	animated_sprite.frames = gun_hands_frames
	$GunCurse.start()
	Global.gun_curse_taken = true

func begin_dying():
	State = States.DEAD
	print("Oh noes!")
	print("Player died!")
	StageManager.current_map.spawn_dialog("PlayerDied")

		
	
func _on_hit(damage):
	health -= damage
	if health <= 0:
		begin_dying()

func detach_camera():
	var camera = find_node("*Camera*")
	if camera != null:
		remove_child(camera)
		get_parent().add_child(camera)
		camera.global_position = global_position
		
		
func fall_off_map():
	if !levitate:
		detach_camera()
		vel = Vector2.ZERO
		State = States.FALLING
		print("oh noes!")
		print("Player fell off the map!")


func stun(time:float) -> void:
	State = States.STUNNED
	yield(get_tree().create_timer(time), "timeout")
	State = States.READY

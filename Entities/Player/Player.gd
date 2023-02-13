extends KinematicBody2D

export var move_speed := 300
onready var animated_sprite: AnimatedSprite = $SpriteRoot/AnimatedSprite
onready var reload_timer: Timer = $ReloadTimer

export(PackedScene) var bullet_scene

var vel := Vector2()
var last_direction : Vector2 = Vector2.ZERO

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

enum States { READY, PUSHING_BLOCK, PAUSED, DEAD }
var State = States.READY


func _ready() -> void:
	Dialogic.has_current_dialog_node()

func _physics_process(delta : float):
	$Debug/StateLabel.text = States.keys()[State]
	if State == States.READY:
		move_normally(delta)
	elif State == States.PUSHING_BLOCK:
		pass # let the customAffordance move you?
		
		

func move_normally(delta : float):
	var move = Vector2()
	if !Dialogic.has_current_dialog_node():
		move = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		#move = move.rotated(PI/4.0) # isometric?
	var target_vel = move.normalized() * move_speed
	vel = vel.linear_interpolate(target_vel, delta * 30)
	# warning-ignore:return_value_discarded
	move_and_slide(vel * Vector2(1,0.5))
	animate_movement(vel)
	

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
	bullet.rotation = get_local_mouse_position().angle()
	get_parent().add_child(bullet)
	bullet.global_position = global_position

func start_gun_curse():
	$GunCurse.start()

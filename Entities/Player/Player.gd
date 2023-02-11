extends KinematicBody2D

export var move_speed := 300
onready var animated_sprite: AnimatedSprite = $SpriteRoot/AnimatedSprite
export(PackedScene) var bullet_scene

var vel := Vector2()

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

func _physics_process(delta : float):
	var move = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target_vel = move.normalized() * move_speed
	vel = vel.linear_interpolate(target_vel, delta * 30)
# warning-ignore:return_value_discarded
	move_and_slide(vel * Vector2(1,0.5))
	
	var anim_array
	if (vel.length() > 10):
		anim_array = run_anim_names
		dir_index = round(Vector2.DOWN.angle_to(vel)/deg2rad(45))
	else:
		anim_array = idle_anim_names
	
	
	animated_sprite.animation = anim_array[abs(dir_index)]
	if dir_index > 0:
		$SpriteRoot.scale.x = 1
	else:
		$SpriteRoot.scale.x = -1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()

func shoot():
	var bullet = bullet_scene.instance() as Node2D
	bullet.rotation = get_local_mouse_position().angle()
	get_parent().add_child(bullet)
	bullet.global_position = global_position

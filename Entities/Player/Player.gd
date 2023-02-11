extends KinematicBody2D

export var move_speed := 300
onready var animated_sprite: AnimatedSprite = $AnimatedSprite
export(PackedScene) var bullet_scene

var vel := Vector2()

func _physics_process(delta : float):
	var move = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target_vel = move.normalized() * move_speed
	vel = vel.linear_interpolate(target_vel, delta * 10)
	move_and_slide(vel * Vector2(1,0.5))
	var f = round(abs(Vector2.DOWN.angle_to(vel))/deg2rad(45))
	if vel.x < 1:
		animated_sprite.scale.x = 1
	if vel.x > 1:
		animated_sprite.scale.x = -1
	animated_sprite.frame = f

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()

func shoot():
	var bullet = bullet_scene.instance() as Node2D
	bullet.rotation = get_local_mouse_position().angle()
	get_parent().add_child(bullet)
	bullet.global_position = global_position

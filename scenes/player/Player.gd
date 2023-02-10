extends KinematicBody2D

export var move_speed := 500

var vel := Vector2()

func _physics_process(delta : float):
	var move = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target_vel = move.normalized() * move_speed
	vel = vel.linear_interpolate(target_vel, delta * 10)
	move_and_slide(vel)

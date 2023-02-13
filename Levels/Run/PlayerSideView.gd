extends KinematicBody2D


enum States { RUNNING, JUMPING, SLIDING, DEAD }
var State = States.RUNNING

var velocity = Vector2.ZERO
var gravity = 50.0
var jump_speed = -18.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("run")


func _unhandled_input(_event):
	if Input.is_action_just_pressed("jump") and $GroundDetector.is_colliding():
		$AnimationPlayer.play("jump")
		State = States.JUMPING
	elif Input.is_action_just_pressed("slide"):
		$AnimationPlayer.play("slide")
		State = States.SLIDING
		
func launch():
	velocity.y = jump_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += gravity * delta
	if is_on_floor() and velocity.y > 0.0:
		velocity = Vector2.ZERO
	#warning-ignore:RETURN_VALUE_DISCARDED
	move_and_collide(velocity)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name in ["jump", "slide"]:
		$AnimationPlayer.play("run")
		

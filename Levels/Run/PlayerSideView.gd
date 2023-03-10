extends KinematicBody2D


enum States { RUNNING, JUMPING, SLIDING, DEAD }
var State = States.RUNNING

var velocity = Vector2.ZERO
var gravity = 50.0
var jump_speed = -18.0

var run_animation_speed = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("run")


func _unhandled_input(_event):
	if Input.is_action_just_pressed("jump") and $GroundDetector.is_colliding():
		slow_down()
		$AnimationPlayer.play("jump")
		State = States.JUMPING
	elif Input.is_action_just_pressed("slide"):
		slow_down()
		$AnimationPlayer.play("slide")
		$CPUParticles2D.emitting = true
		State = States.SLIDING
		
func launch():
	velocity.y = jump_speed
	$CPUParticles2D.emitting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += gravity * delta
	if is_on_floor() and velocity.y > 0.0:
		velocity = Vector2.ZERO
	#warning-ignore:RETURN_VALUE_DISCARDED
	move_and_collide(velocity)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name in ["jump", "slide", "stumble", "recoil"]:
		$AnimationPlayer.set_speed_scale(run_animation_speed)
		$AnimationPlayer.play("run")
		if run_animation_speed > 1.0:
			$CPUParticles2D.emitting = true

func speed_up(speedMultiplier : float = 1.0):
	run_animation_speed = speedMultiplier
	$AnimationPlayer.set_speed_scale(run_animation_speed)
	$CPUParticles2D.emitting = true
	
func slow_down():
	$AnimationPlayer.set_speed_scale(1.0)
	

func stop():
	$AnimationPlayer.play("idle")
	$CPUParticles2D.emitting = false
	
func start():
	$AnimationPlayer.play("run")
	if run_animation_speed > 1.0:
		$CPUParticles2D.emitting = true

func _on_hit(body):
	if body.get("walking") == true:
		$AnimationPlayer.play("stumble")
	elif body.get("flying") == true:
		$AnimationPlayer.play("recoil")

	Global.player_health_remaining -= 1
	if Global.player_health_remaining <= 0:
		print("Player Died")
		
		get_parent()._on_runner_died()
		call_deferred("queue_free")

func _on_Hurtbox_body_entered(body):
	if $iframes.is_stopped():
		if body.has_method("hit"):
			body.hit()
			self._on_hit(body)
		else:
			$iframes.start()

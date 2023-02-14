extends KinematicBody2D


enum States { RUNNING, JUMPING, SLIDING, DEAD }
var State = States.RUNNING

var velocity = Vector2.ZERO
var gravity = 50.0
var jump_speed = -18.0

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.speed_curse_taken:
		speed_up()
	$AnimationPlayer.play("run")


func _unhandled_input(_event):
	if Input.is_action_just_pressed("jump") and $GroundDetector.is_colliding():
		slow_down()
		$AnimationPlayer.play("jump")
		State = States.JUMPING
	elif Input.is_action_just_pressed("slide"):
		slow_down()
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
		if Global.speed_curse_taken:
			speed_up()
		$AnimationPlayer.play("run")

func speed_up():
	$AnimationPlayer.set_speed_scale(2.0)

func slow_down():
	$AnimationPlayer.set_speed_scale(1.0)
	

func remove_heart():
	var hearts = $HUD/Control/HBoxContainer/GridContainer.get_children()
	if hearts.size() > 0:
		hearts.pop_back().queue_free()

func _on_Hurtbox_body_entered(body):
	if $iframes.is_stopped():
		if body.has_method("hit"):
			body.hit()
			remove_heart()
			Global.player_health_remaining -= 1
			if Global.player_health_remaining < 0:
				print("Player Died")
				
				get_parent()._on_runner_died()
				call_deferred("queue_free")
		else:
			$iframes.start()

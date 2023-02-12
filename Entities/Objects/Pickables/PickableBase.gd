extends Area2D


export var magnet_enabled : bool = true
var speed = 360.0
var attractant : Node2D # probably Player

enum States { IDLE, CHARGING, MAGNETIZED }
var State = States.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if State == States.CHARGING and attractant != null and is_instance_valid(attractant):
		move_away_from_attractant(delta)
	if State == States.MAGNETIZED and attractant != null and is_instance_valid(attractant):
		move_toward_attractant(delta)
		
		
func move_toward_attractant(delta):
	var dir = self.global_position.direction_to(attractant.global_position)
	position += dir * speed * delta

func move_away_from_attractant(delta):
	var dir = -1 * (self.global_position.direction_to(attractant.global_position))
	position += dir * speed * delta


func pickup(body):
	# make a noise, disappear and notify the consuming body
	$PickupNoise.start()
	if body.has_method("_on_pickable_picked_up"):
		#warning-ignore:RETURN_VALUE_DISCARDED
		connect("picked_up", body, "_on_pickable_picked_up")
		emit_signal("picked_up")
	$AnimationPlayer.play("picked_up")
	

func _on_Pickable_body_entered(body):
	if body.name == "Player":
		pickup(body)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "picked_up":
		queue_free()


func _on_MagnetArea_body_entered(body):
	# quickly move away from player
	if magnet_enabled:
		if State == States.IDLE:
			$ChargeTimer.start()
			State = States.CHARGING
			attractant = body


func _on_ChargeTimer_timeout():
	# move toward player
	if magnet_enabled and State == States.CHARGING:
		State = States.MAGNETIZED

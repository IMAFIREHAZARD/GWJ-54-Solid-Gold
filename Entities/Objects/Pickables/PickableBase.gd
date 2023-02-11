extends Area2D


export var magnet_enabled : bool = true
var speed = 20.0
var attractant : Node2D # probably Player

enum States { IDLE, MAGNETIZED }
var State = States.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if State == States.MAGNETIZED and attractant != null and is_instance_valid(attractant):
		move_toward_attractant(delta)
		
func move_toward_attractant(delta):
	var dir = self.global_position.direction_to(attractant.global_position)
	position += dir * speed * delta


func pickup(body):
	# make a noise, disappear and notify the consuming body
	$PickupNoise.start()
	if body.has_method("_on_pickable_picked_up"):
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
	if magnet_enabled:
		State = States.MAGNETIZED
		attractant = body

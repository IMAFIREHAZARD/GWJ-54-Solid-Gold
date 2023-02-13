extends Area2D
onready var ray_cast_2d: RayCast2D = $RayCast2D

export var speed = 1000
var active = true

func _physics_process(delta: float) -> void:
	global_position += transform.x * speed * delta


func _on_Bullet_body_entered(body: Node) -> void:
	if not active: return
	if body.has_method("kill"):
		body.kill()
	active = false
	$AnimationPlayer.play("Hit")
	speed = 0
	yield($AnimationPlayer,"animation_finished")
	queue_free()

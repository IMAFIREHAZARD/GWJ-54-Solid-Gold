extends Area2D
onready var ray_cast_2d: RayCast2D = $RayCast2D

export var speed = 1000
var active = true

func _ready() -> void:
	$AudioStreamPlayer.pitch_scale = rand_range(0.9, 1.1)

func _physics_process(delta: float) -> void:
	global_position += transform.x * speed * delta


func _on_Bullet_body_entered(body: Node) -> void:
	if not active: return
	if body.has_method("kill") and body.name != "Player":
		body.kill()
	elif body.name == "Player" and body.has_method("_on_hit"):
		body._on_hit(1) # 1 damage
	elif body.has_method("explode_into_smithereens") and body.get("fragile") == true:
		body.explode_into_smithereens()
	active = false
	$AnimatedSprite.hide()
	$Explosion/AnimatedSprite.show()
	$Explosion/AnimatedSprite.play("default")
	speed = 0
	yield($Explosion/AnimatedSprite,"animation_finished")
	queue_free()


func _on_Timer_timeout() -> void:
	queue_free()


func _on_Bullet_area_entered(area: Area2D) -> void:
	_on_Bullet_body_entered(area)

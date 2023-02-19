extends Area2D

var travel_dir : Vector2 = Vector2.RIGHT
var speed = 600

func _ready() -> void:
	$AnimatedSprite.rotation = travel_dir.angle()

func _physics_process(delta: float) -> void:
	global_position += travel_dir.normalized() * speed * delta


func _on_Area2D_body_entered(body: Node) -> void:
	if "Boss" in body.name:
		return

	elif body == StageManager.player:
		StageManager.player._on_hit(1)
		queue_free()
	elif body.has_method("explode_into_smithereens") and body.get("fragile") == true:
			body.explode_into_smithereens()
	else: #walls and obstacles
		queue_free()


func _on_Timer_timeout() -> void:
	queue_free()

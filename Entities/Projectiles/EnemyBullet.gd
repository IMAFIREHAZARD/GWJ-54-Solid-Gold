extends Area2D

var travel_dir : Vector2
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
	else: #walls and obstacles
		print(body.name)
		queue_free()


func _on_Timer_timeout() -> void:
	queue_free()

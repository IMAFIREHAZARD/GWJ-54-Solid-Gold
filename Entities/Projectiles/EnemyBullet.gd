extends Area2D

var travel_dir : Vector2
var speed = 600

func _ready() -> void:
	$AnimatedSprite.rotation = travel_dir.angle()

func _physics_process(delta: float) -> void:
	global_position += travel_dir.normalized() * speed * delta


func _on_Area2D_body_entered(body: Node) -> void:
	if body == StageManager.player:
		StageManager.player._on_hit(1)
		queue_free()


func _on_Timer_timeout() -> void:
	queue_free()

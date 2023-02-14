extends Area2D

var travel_dir : Vector2
var speed = 600

func _physics_process(delta: float) -> void:
	global_position += travel_dir.normalized() * speed * delta


func _on_Area2D_body_entered(body: Node) -> void:
	queue_free()

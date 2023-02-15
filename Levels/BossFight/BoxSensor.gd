class_name BoxSensor extends Area2D

signal block_entered()
signal block_exited()

func _on_BoxSensor_body_entered(body: Node) -> void:
	print(body)
	if body is PushBlock:
		emit_signal("block_entered")


func _on_BoxSensor_body_exited(body: Node) -> void:
	if body is PushBlock:
		emit_signal("block_exited")

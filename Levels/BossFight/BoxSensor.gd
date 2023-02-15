extends Area2D

signal block_entered(block)
signal block_exited(block)

func _on_BoxSensor_body_entered(body: Node) -> void:
	print(body)
	if body is SokobanBlock:
		emit_signal("block_entered", body)
		$Line2D.default_color = Color.greenyellow


func _on_BoxSensor_body_exited(body: Node) -> void:
	if body is SokobanBlock:
		emit_signal("block_exited", body)
		$Line2D.default_color = Color.cornflower

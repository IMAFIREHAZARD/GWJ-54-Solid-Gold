extends Node2D




func _on_Area2D_body_entered(body):
	if body.name == "Player":
		create_tween().tween_property(self, "modulate", Color(1,1,1,0.75), 0.2)


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		create_tween().tween_property(self, "modulate", Color.white, 0.2)

extends Node2D




func _on_Area2D_body_entered(body):
	if body.name == "Player":
		set_modulate(Color(1,1,1,0.5))


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		set_modulate(Color.white)

extends Area2D


export var direction_vector : Vector2 = Vector2(2, 1)


signal player_entered

func _ready():
	if direction_vector.x < 0:
		$Arrow.set_flip_h(true)
	if direction_vector.y < 0:
		$Arrow.set_flip_v(true)
	$Arrow.hide()

func _on_PushZone_body_entered(body):
	if body.name == "Player":
		$Arrow.show()
		emit_signal("player_entered", direction_vector)


func _on_PushZone_body_exited(body):
	if body.name == "Player":
		$Arrow.hide()

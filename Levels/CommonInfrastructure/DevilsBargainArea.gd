extends Area2D

export (String) var timeline : String = "DevilsBargain"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass





func _on_DevilsBargainArea_body_entered(body):
	if body.name == "Player":
		var new_dialog = Dialogic.start(timeline)
		add_child(new_dialog)

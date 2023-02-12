extends Area2D

signal accept_curse()

export (String, "TimelineDropdown") var timeline

func _on_DevilsBargainArea_body_entered(body):
	if body.name == "Player":
		var new_dialog = Dialogic.start(timeline)
		add_child(new_dialog)
		new_dialog.connect("dialogic_signal", self, "_on_dialogic_signal")

func _on_dialogic_signal(param):
	if param == "accept":
		emit_signal("accept_curse")

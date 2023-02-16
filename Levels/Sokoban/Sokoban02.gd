extends "res://Levels/CommonInfrastructure/MinimalLevel.gd"

var hovered_block = null

func _physics_process(_delta: float) -> void:
	hovered_block = null


func _on_DevilsBargainTimer_timeout():
	if Global.curses_taken["strength"] == false:
		Global.curses_offered["strength"] = true
		spawn_dialog("StrengthCurse")
		
func spawn_dialog(dialogic_timeline):
	var new_dialog = Dialogic.start(dialogic_timeline)
	add_child(new_dialog)
	new_dialog.connect("dialogic_signal", self, "_on_dialogic_signal")

func _on_dialogic_signal(signalName):
	if signalName == "strength_curse_accepted":
		Global.curses_taken["strength"] = true
	

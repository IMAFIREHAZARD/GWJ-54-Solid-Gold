extends Node2D

export (String, "TimelineDropdown") var dialogic_timeline
export var curse : String
export var wait_time : float = 30.0

signal curse_accepted

func _ready():
	
	if !Global.curses_taken[curse]:
		$Timer.set_wait_time(wait_time)
		#warning-ignore:RETURN_VALUE_DISCARDED
		$Timer.connect("timeout", self, "_on_timer_timeout")
		$Timer.start()
		if StageManager.current_map != null and StageManager.current_map.has_method("_on_curse_accepted"):
			#warning-ignore:RETURN_VALUE_DISCARDED
			connect("curse_accepted", StageManager.current_map, "_on_curse_accepted")
	else:
		pass # player already has the boon/curse.


func _on_DevilsBargainTimer_timeout():
	if curse == null or curse == "":
		printerr("TimedDevilsBargain.gd. Needs curse to be defined in inspector. For: ", get_parent().name, " on ", StageManager.current_map.name)
		return
		
	if Global.curses_taken[curse] == false:
		Global.curses_offered[curse] = true
		spawn_dialog()
		
func spawn_dialog():
	var new_dialog = Dialogic.start(dialogic_timeline)
	add_child(new_dialog)
	new_dialog.connect("dialogic_signal", self, "_on_dialogic_signal")

func _on_dialogic_signal(signalName):
	if signalName == "curse_accepted":
		Global.curses_taken[curse] = true
		emit_signal("curse_accepted", curse)
	
func _on_timer_timeout():
	spawn_dialog()

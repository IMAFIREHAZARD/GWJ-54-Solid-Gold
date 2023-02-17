extends "res://Levels/BaseLevel.gd"

export var max_bugs = 8
var current_bugs = 0
var victory_popup_offered : bool = false

export(String, "TimelineDropdown") var success_timeline

func _ready() -> void:
	#warning-ignore:RETURN_VALUE_DISCARDED
	$YSort/Critters.connect("child_exiting_tree", self, "_on_bug_died", [], CONNECT_DEFERRED)

func _on_bug_died(_v):
	if current_bugs == 0 and victory_popup_offered == false:
		
		if Dialogic.has_current_dialog_node():
			yield(get_tree().get_meta('latest_dialogic_node'), "timeline_end")
		victory_popup_offered = true
		var dialog = Dialogic.start(success_timeline)
		add_child(dialog)
		dialog.connect("dialogic_signal", self, "reveal_exit")

func reveal_exit(_v):
	$Exit.show()
	$Exit.monitoring = true

func _on_curse_accepted(curseName):
	if curseName == "gun_hands":
		StageManager.player.start_gun_curse()

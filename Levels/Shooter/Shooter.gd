extends "res://Levels/CommonInfrastructure/MinimalLevel.gd"

export var max_bugs = 8
var current_bugs = 0

export(String, "TimelineDropdown") var success_timeline

func _ready() -> void:
	$YSort/Critters.connect("child_exiting_tree", self, "_on_bug_died", [], CONNECT_DEFERRED)

func _on_bug_died(_v):
	if current_bugs == 0:
		if Dialogic.has_current_dialog_node():
			yield(get_tree().get_meta('latest_dialogic_node'), "timeline_end")
		
		var dialog = Dialogic.start(success_timeline)
		add_child(dialog)
		dialog.connect("dialogic_signal", self, "reveal_exit")

func reveal_exit(_v):
	$Exit.show()
	$Exit.monitoring = true

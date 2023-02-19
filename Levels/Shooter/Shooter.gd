extends "res://Levels/BaseLevel.gd"

export var max_bugs = 8
var current_bugs = 0
var victory_popup_offered : bool = false

export(String, "TimelineDropdown") var success_timeline

var paused

func _ready() -> void:
	#warning-ignore:RETURN_VALUE_DISCARDED
	$YSort/Critters.connect("child_exiting_tree", self, "_on_bug_died", [], CONNECT_DEFERRED)

func _on_bug_died(_v):
	if current_bugs <= 3  and victory_popup_offered == false:
		destroy_all_bugs()
		if Dialogic.has_current_dialog_node():
			yield(get_tree().get_meta('latest_dialogic_node'), "timeline_end")
		victory_popup_offered = true
		var dialog = Dialogic.start(success_timeline)
		add_child(dialog)
		#dialog.connect("dialogic_signal", self, "reveal_exit")
		dialog.connect("dialogic_signal", self, "_on_dialogic_signal")

func reveal_exit(_v):
	$Exit.show()
	$Exit.monitoring = true

func _on_dialogic_signal(signal_params):
	if signal_params == "BugsKilled":
		destroy_all_bugs()
		teleport_to_bossfight()
	elif signal_params == "restart_level":
		StageManager.restart_current_level()

func destroy_all_bugs():
	var bugs = get_tree().get_nodes_in_group("critters")
	for bug in bugs:
		if bug.has_method("kill"):
			bug.kill()
		else:
			bug.queue_free()

func teleport_to_bossfight():
	StageManager.change_scene("res://Levels/BossFight/BossFight.tscn")

func _on_curse_accepted(curseName):
	if curseName == "gun_hands":
		StageManager.player.start_gun_curse()

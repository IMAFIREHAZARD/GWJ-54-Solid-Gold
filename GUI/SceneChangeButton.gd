extends "res://GUI/GenericButton.gd"


export var target_scene : PackedScene
# Godot will complain about circular references if a packedScene leads back to anohter loaded scene.
# in those cases, target_scene_path can be used.
export var target_scene_path : String


export (String, "TimelineDropdown") var dialogic_timeline


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_GenericButton_pressed():
	$ClickNoise.start_persistant()
	if dialogic_timeline != null and dialogic_timeline != "":
		if dialogic_timeline == "timeline-1676377628.json" and Global.curses_taken["strength"] == false:
			spawn_dialog()
		else:
			change_scene()
	else:
		change_scene()

# If the player clicks the restart level button,
# consider that like failing a level.
# The design spec calls for a devil's bargain at that time.
func spawn_dialog():
	var new_dialog = Dialogic.start(dialogic_timeline)
	add_child(new_dialog)
	new_dialog.connect("dialogic_signal", self, "_on_dialogic_signal")

func _on_dialogic_signal(signalName):
	if signalName == "strength_curse_accepted":
		Global.curses_taken["strength"] = true
	change_scene()
	
func change_scene():
	if target_scene == null:
		if target_scene_path != "":
			StageManager.change_scene(target_scene_path)
		else:
			printerr("SceneChangeButton.gd " + self.name + " needs target_scene or target_scene_path")
	else:
		StageManager.change_scene_to(target_scene)
		

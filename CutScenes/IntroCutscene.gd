extends Control


export (String, "TimelineDropdown") var dialogic_timeline
export var target_scene : PackedScene
export var target_scene_path : String


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_dialogic_signal(_signalName):
	# in case you have clever dialogs with questions and stuff
	pass

	
func change_scene():
	if target_scene == null:
		if target_scene_path != "":
			StageManager.change_scene(target_scene_path)
		else:
			printerr("SceneChangeButton.gd " + self.name + " needs target_scene or target_scene_path")
	else:
		StageManager.change_scene_to(target_scene)
		



func _on_Dialog_timeline_end(_timeline_name):
	change_scene()

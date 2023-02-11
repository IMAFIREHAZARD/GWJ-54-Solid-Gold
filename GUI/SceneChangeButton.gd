extends "res://GUI/GenericButton.gd"


export var target_scene : PackedScene
# Godot will complain about circular references if a packedScene leads back to anohter loaded scene.
# in those cases, target_scene_path can be used.
export var target_scene_path : String


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_GenericButton_pressed():
	$ClickNoise.start()
	if target_scene == null:
		if target_scene_path != "":
			StageManager.change_scene(target_scene_path)
		else:
			printerr("SceneChangeButton.gd " + self.name + " needs target_scene or target_scene_path")
	else:
		StageManager.change_scene_to(target_scene)
		

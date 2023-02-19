extends "res://Levels/CommonInfrastructure/MinimalLevel.gd"

var hovered_block = null
var cam : Camera2D
var intro_played : bool = false 

func _ready():
	cam = find_node("Camera2D")
	cam.current = true
	
	if Global.scene_attempts["Sokoban"] == 0:
		play_intro_dialog()
	else:
		skip_intro_dialog()
	Global.scene_attempts["Sokoban"] += 1
	

	
	
func play_intro_dialog():
	if not intro_played:
		spawn_dialog("SokobanIntro")
		intro_played = true

func skip_intro_dialog():
	
	pan_camera(StageManager.player.global_position, 2.0)
	


func pan_camera(target : Vector2, time := 1.0):
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(cam, "global_position", target, time)
	yield(tween, "finished")

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
	new_dialog.connect("timeline_end", self, "_on_dialogic_timeline_ended")
	return new_dialog

func _on_dialogic_signal(signalName):
	if signalName == "strength_curse_accepted":
		Global.curses_taken["strength"] = true
	
func _on_dialogic_timeline_ended(timelineName):
	if timelineName == "SokobanIntro":
		pan_camera(StageManager.player.global_position, 2.0)

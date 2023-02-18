extends "res://Levels/CommonInfrastructure/MinimalLevel.gd"

var hovered_block = null
var cam : Camera2D
 
func _ready():
	play_intro_dialog()
	cam = find_node("Camera2D")
	cam.current = true
	
	
func play_intro_dialog():
	var dialog = spawn_dialog("SokobanIntro")
	
	


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

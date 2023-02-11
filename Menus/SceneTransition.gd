extends CanvasLayer

signal FadedOut
signal FadedIn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func start():
	
	pass
	

func fade_out():
	print("fading out")
	$AnimationPlayer.play("FadeOut")
	
func fade_in():
	print("fading in")
	$AnimationPlayer.play("FadeIn")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeOut":
		emit_signal("FadedOut")
	
	elif anim_name == "FadeIn":
		emit_signal("FadedIn")


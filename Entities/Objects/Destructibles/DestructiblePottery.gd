extends Node2D


var fragile : bool = true



# Called when the node enters the scene tree for the first time.
func _ready():
	show_random_image()
	
func show_random_image():
	var images = $Sprites.get_children()
	for image in images:
		image.hide()
	var randImage = images[randi()%images.size()]
	randImage.show()
	

func explode_into_smithereens():
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("explode")
	$SmashNoises.play_random_noise()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "explode":
		call_deferred("queue_free")

extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$HeartTemplate.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if Global.player_health_remaining != $GridContainer.get_child_count():
		for heart in $GridContainer.get_children():
			heart.queue_free()
		for _i in range(Global.player_health_remaining):
			var newHeart = $HeartTemplate.duplicate()
			$GridContainer.add_child(newHeart)
			newHeart.show()

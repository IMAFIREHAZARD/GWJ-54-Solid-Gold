extends HBoxContainer


var textures = {
	"full":"res://GUI/HUD/Heart.png",
	"empty":"res://GUI/HUD/HeartEmpty.png",
	"locked":"res://GUI/HUD/lockedHeart02.png",
}


# Called when the node enters the scene tree for the first time.
func _ready():
	$HeartTemplate.hide()
	for i in range(Global.player_max_health):
		var newHeart = $HeartTemplate.duplicate()
		$GridContainer.add_child(newHeart)
		newHeart.show()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if Global.get_num_curses() > 0:
		pass
	
	var hearts = $GridContainer.get_children()
	while hearts.size() > 0:
		var current_heart = hearts.pop_back()
		if Global.player_max_health - current_heart.get_position_in_parent() <= Global.get_num_curses():
			current_heart.texture = load(textures["locked"])
		elif Global.player_health_remaining <= current_heart.get_position_in_parent():
			current_heart.texture = load(textures["empty"])
		else:
			current_heart.texture = load(textures["full"])
		
		
			
			
			

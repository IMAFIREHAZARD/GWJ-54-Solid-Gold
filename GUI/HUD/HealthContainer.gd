extends Control


var textures = {
	"full":preload("res://GUI/HUD/Heart.png"),
	"empty":preload("res://GUI/HUD/HeartEmpty.png"),
	"locked":preload("res://GUI/HUD/lockedHeart02.png"),
}
var prev_health = Global.player_health_remaining
onready var grid_container: GridContainer = $"%GridContainer"

# Called when the node enters the scene tree for the first time.
func _ready():
	$HeartTemplate.hide()
	for i in range(Global.player_max_health):
		var newHeart = $HeartTemplate.duplicate()
		grid_container.add_child(newHeart)
		newHeart.show()

func _physics_process(_delta: float) -> void:
	if Global.get_num_curses() > 0:
		pass
	
	var hearts = grid_container.get_children()
	while hearts.size() > 0:
		var current_heart = hearts.pop_back()
		if Global.player_max_health - current_heart.get_position_in_parent() <= Global.get_num_curses():
			current_heart.texture = textures["locked"]
		elif Global.player_health_remaining <= current_heart.get_position_in_parent():
			current_heart.texture = textures["empty"]
			if Global.player_health_remaining < prev_health:
				current_heart.pop()
			
		else:
			current_heart.texture = textures["full"]
		
	prev_health = Global.player_health_remaining
			
			
			

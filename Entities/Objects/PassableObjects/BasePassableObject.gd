extends StaticBody2D

onready var colPol = get_node("Polygon2D")
var player
export var opacity = 0.5;
func _ready():
	pass # Replace with function body.


func set_player(player_):
	player = player_

func _physics_process(delta):
	# check if player assigned
	if player == null: return
	# check if player in polygon
	if (Geometry.is_point_in_polygon(player.position-position,colPol.polygon)):
		modulate = Color(1,1,1,opacity)
	else:
		modulate = Color(1,1,1,1)
	

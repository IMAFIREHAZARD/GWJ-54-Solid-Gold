extends Position2D


var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var height_offset = Vector2(0, -76)
	var distance_offset_magnitude = 80.0
	var newDirection = (player.global_position).direction_to(get_global_mouse_position())
	newDirection.y = newDirection.y / 2.0
	set_global_position(player.global_position + newDirection.normalized() * distance_offset_magnitude + height_offset)
	

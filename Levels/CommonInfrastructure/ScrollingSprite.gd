extends Sprite

export var base_speed : float = 900.0
var speed : float = base_speed



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	region_rect.position.x += speed * delta

func speed_up(speed_multiplier):
	speed = base_speed * speed_multiplier

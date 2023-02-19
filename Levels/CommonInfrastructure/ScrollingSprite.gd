extends Sprite

export var base_speed : float = 20.0
export var z_parallax : float = 1.0
var speed : float = base_speed



# Called when the node enters the scene tree for the first time.
func _ready():
	speed_up(1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	region_rect.position.x += speed * z_parallax * delta

func speed_up(speed_multiplier : float):
	speed = base_speed * speed_multiplier
	

extends Sprite


export var duration : float = 3.5

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = get_tree().create_timer(duration)
	yield(timer, "timeout")
	queue_free()
	

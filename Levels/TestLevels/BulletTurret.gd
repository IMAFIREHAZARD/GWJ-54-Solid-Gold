extends Position2D


var last_polling_time : float = 0.0
var polling_interval : float = 1000.0 # msec


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Time.get_ticks_msec() > last_polling_time + polling_interval:
		last_polling_time = Time.get_ticks_msec()
		spawn_bullet()
		
func spawn_bullet():
	var bullet = preload("res://Entities/Projectiles/Bullet.tscn").instance()
	add_child(bullet)
	
	bullet.rotation = rotation
	bullet.global_position = global_position



extends Camera2D


var default_zoom : Vector2
var distant_zoom : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	default_zoom = zoom
	distant_zoom = 3.0 * zoom

func _unhandled_input(event):
	if Input.is_action_just_pressed("zoom_out"):
		zoom = distant_zoom
	elif Input.is_action_just_pressed("zoom_in"):
		zoom = default_zoom


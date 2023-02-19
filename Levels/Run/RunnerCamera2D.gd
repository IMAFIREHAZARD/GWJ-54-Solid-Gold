extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	current = true

func speed_up():
	var final_zoom = Vector2(1.5,1.5)
	var final_offset = Vector2(0, -get_viewport().size.y / 3.0)
	var tween = get_tree().create_tween()
	
	tween.parallel().tween_property(self, "zoom", final_zoom, 1.0 )
	#tween.parallel().tween_property(self, "offset", final_offset, 1.0 )
	
	#zoom = Vector2(2,2)
	#offset = Vector2(0,-600)
	self.current = true

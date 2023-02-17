extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func spawn_crack():
	var newCrack = $CrackTemplate.duplicate()
	newCrack.set_frame(randi()%newCrack.hframes)
	add_child(newCrack)

	newCrack.show()

	var extents = $ReferenceRect.get_rect()
	var xPos = rand_range(extents.position.x, extents.size.x )
	var yPos = rand_range(extents.position.y, extents.size.y )
	newCrack.position = Vector2(xPos, yPos)
	newCrack.rotation = randf()*TAU

func _unhandled_input(event):
	if Input.is_action_just_pressed("test_cracks"):
		spawn_crack()

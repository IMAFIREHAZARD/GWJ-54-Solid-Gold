extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_hit(damage):
	# bullets hit this static body, but it's merely a child of the boss proper.
	get_parent()._on_hit(damage)

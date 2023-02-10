extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func start():
	var new_sound = self.duplicate()
	new_sound.connect("finished", new_sound, "_on_finished")
	get_parent().add_child(new_sound)
	
	new_sound.play()
	
func _on_finished():
	queue_free()
	

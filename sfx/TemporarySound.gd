extends AudioStreamPlayer


export var pitch_shift : bool = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func start():
	var new_sound = self.duplicate()
	new_sound.connect("finished", new_sound, "_on_finished")
	get_parent().add_child(new_sound)
	
	if pitch_shift:
		new_sound.set_pitch_scale(rand_range(0.9, 1.1))
	new_sound.play()
	

func start_persistant():
	var new_sound = self.duplicate()
	new_sound.connect("finished", new_sound, "_on_finished")
	get_tree().get_root().add_child(new_sound)
	
	if pitch_shift:
		new_sound.set_pitch_scale(rand_range(0.9, 1.1))
	new_sound.play()
	
	
func _on_finished():
	queue_free()
	

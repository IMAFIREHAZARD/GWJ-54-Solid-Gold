extends AudioStreamPlayer


export var pitch_shift : float = 0.0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func start():
	var new_sound = self.duplicate()
	new_sound.connect("finished", new_sound, "_on_finished")
	get_parent().add_child(new_sound)
	
	new_sound.set_pitch_scale(rand_range(1.0-pitch_shift, 1.0+pitch_shift))
	new_sound.play()
	
func start_persistant():
	start_persistent() # damn tricky spellings

func start_persistent():
	var new_sound = self.duplicate()
	new_sound.connect("finished", new_sound, "_on_finished")
	get_tree().get_root().add_child(new_sound)
	
	if pitch_shift:
		new_sound.set_pitch_scale(rand_range(1.0-pitch_shift, 1.0+pitch_shift) * pitch_scale)
	new_sound.play()

func start_without_duplicate():
	#warning-ignore:RETURN_VALUE_DISCARDED
	self.connect("finished", self, "_on_finished")
	
	
func _on_finished():
	queue_free()
	

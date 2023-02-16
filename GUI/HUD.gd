extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = get_tree().create_timer(0.5)
	yield(timer, "timeout")
	if is_instance_valid(self):
		delayed_ready()

func delayed_ready():
	# call this after ancestors have loaded
	if StageManager.current_map != null and is_instance_valid(StageManager.current_map):
		$Header/HBox/Label.text = StageManager.current_map.name
	$Header/HBox/ResetLevelButton.target_scene = StageManager.current_packed_scene

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

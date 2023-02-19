extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _enter_tree():
	StageManager.hud = self
	

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = get_tree().create_timer(0.5)
	yield(timer, "timeout")
	if is_instance_valid(self):
		delayed_ready()

func delayed_ready():
	# call this after ancestors have loaded
	update_instructions()
	
func update_instructions():
	if StageManager.current_map != null and is_instance_valid(StageManager.current_map):
		var map = StageManager.current_map
		var instructions = ""
		if map.name == "Shooter":
			instructions = "Bugs Remaining: " + str( map.current_bugs )
		elif map.name == "BossFight":
			instructions = "Find a way to destroy the Angel."
		elif map.name == "Sokoban":
			instructions = "Escape the maze"
		elif map.name == "Runner":
			instructions = "Get to the exit!"
		
		$Header/HBox/LevelInstructions.text = instructions
	$Header/HBox/ResetLevelButton.target_scene = StageManager.current_packed_scene

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_bug_died():
	if StageManager.current_map.name == "Shooter":
		update_instructions()
		

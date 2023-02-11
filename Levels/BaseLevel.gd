extends Node2D

onready var cam:Camera2D = get_node("Camera2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	StageManager.current_map = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	

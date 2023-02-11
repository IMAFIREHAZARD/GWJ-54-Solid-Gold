extends Node2D


export (String) var timeline : String = "DevilsBargain"


# Called when the node enters the scene tree for the first time.
func _ready():
	var new_dialog = Dialogic.start(timeline)
	add_child(new_dialog)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

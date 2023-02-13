extends "res://Levels/CommonInfrastructure/MinimalLevel.gd"

var hovered_block = null

func _physics_process(_delta: float) -> void:
	hovered_block = null

# an autoload that manages mouse picking for sokoban blocks
extends Node

var hovered_blocks := []
var front_hovered_block : PushBlock = null

func _ready() -> void:
	set_physics_process_internal(true)

func _notification(what: int) -> void:
	# Happens right after viewport picking
	if what == NOTIFICATION_INTERNAL_PHYSICS_PROCESS:
		
		if hovered_blocks.empty():
			if front_hovered_block and is_instance_valid(front_hovered_block):
				front_hovered_block.set_highlighted(false)
			front_hovered_block = null
			return
		# find hovered block with highest y position
		var front_block = hovered_blocks[0]
		for block in hovered_blocks:
			if block.global_position.y > front_block.global_position.y:
				front_block = block
		if front_hovered_block and front_block != front_hovered_block:
			if is_instance_valid(front_hovered_block):
				front_hovered_block.set_highlighted(false)
		front_hovered_block = front_block

extends "res://Levels/BaseLevel.gd"

onready var destructionCenter:Position2D = get_node("DestructionCenter")
onready var destructionTimer:Timer = get_node("DestructionTimer")

var local_destructioncenter
var destruction_dist = 0
var destruction_step = 256
func _ready():
	## prior stuff
	StageManager.current_map = self
	assign_player2passObjs()
	## Pit stuff
	local_destructioncenter = tileMapGround.to_local(destructionCenter.global_position)
	# connect Destruction Timer
	var _a = destructionTimer.connect("timeout",self,"destroy")
	destructionTimer.wait_time = 1
	destructionTimer.one_shot = false
	destructionTimer.start()


func destroy():
	## iterate through all ground tiles and check distance
	for tile_coord in tileMapGround.get_used_cells():
		var tile_pos = tileMapGround.map_to_world(tile_coord)
		#var global_pos = tileMapGround.to_global(local_pos)
		# calc dist
		var dist = tile_pos.distance_to(local_destructioncenter)
		if dist<destruction_dist:
			### DESTRUCTION ANIMATION OR SOMETHING
			tileMapGround.set_cell(tile_coord[0],tile_coord[1],-1)
	## increment destruction dist
	destruction_dist+=destruction_step

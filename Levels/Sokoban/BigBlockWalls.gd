extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_objects_from_tilemap()
	


func spawn_objects_from_tilemap():
	for cellPos in get_used_cells():
		var cellID = get_cellv(cellPos)
		var cellName = tile_set.tile_get_name(cellID)
		if cellName == "FixedWall":
			# add the object
			var newCube = preload("res://Levels/Sokoban/TranslucentWall.tscn").instance()
			add_child(newCube)
			newCube.position = map_to_world(cellPos) * scale
			set_cellv(cellPos, -1) # remove the tile


func get_tile_underneath(pos_global:Vector2):
		
	var local_position = to_local(pos_global)
	var map_position = world_to_map(local_position)
	var tileSet = tile_set
	var tileID = get_cellv(map_position)
	if tileID != -1:
		var tileName = tileSet.tile_get_name(tileID)
		return tileName
	else:
		return "Void"



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

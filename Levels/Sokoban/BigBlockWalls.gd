"""
Convert tilemap images into objects from a scene.
The objects are sokoban blocks which the player can push around.
This node must be provided with another tilemap representing solid ground.

"""

tool
extends TileMap


export var ground_tilemap : NodePath



# Called when the node enters the scene tree for the first time.
func _ready():
	
	if Engine.editor_hint:
		return
		
		
	var tiles = {
		"FixedWall":"res://Levels/Sokoban/TranslucentWall.tscn",
		#"PushBlock":"res://Entities/Objects/Pushables/KickCube128.tscn",
		"PushBlock":"res://Entities/Objects/Pushables/SokobanCubeKinematic.tscn",
		"RedBlock":"res://Entities/Objects/Pickables/RedCube_Pickable.tscn",
	}

	for tileName in tiles.keys():
		spawn_objects_from_tilemap(tileName, tiles[tileName])
	
func _get_configuration_warning():
	if ground_tilemap.is_empty():
		return "BigBlockWalls tilemap must be provided with another tilemap representing the ground. This allows blocks to fall when they're over an empty tile."
	else:
		return ""
		

func spawn_objects_from_tilemap(tileName : String, scenePath : String):
	if scenePath != "":
		for cellPos in get_used_cells():
			var cellID = get_cellv(cellPos)
			var cellName = tile_set.tile_get_name(cellID)
			if cellName == tileName:
				var newCube = load(scenePath).instance()
				set_cellv(cellPos, -1) # remove the tile
				if newCube.has_method("set_tilemap"):
					newCube.set_tilemap(get_node(ground_tilemap)) # must be a child of another tilemap representing the ground
				add_child(newCube)
				newCube.position = map_to_world(cellPos) * scale

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

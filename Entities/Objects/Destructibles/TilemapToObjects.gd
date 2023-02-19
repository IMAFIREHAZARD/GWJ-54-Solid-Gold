"""
Convert tilemap images into objects from a scene.
The objects are sokoban blocks which the player can push around.
This node must be provided with another tilemap representing solid ground.

"""

tool
extends TileMap


export var ground_tilemap : NodePath
export var obj_offset : Vector2 = Vector2(0,0) # fudge the exact placement of the object in case tilemaps don't line up.


# Called when the node enters the scene tree for the first time.
func _ready():
	
	if Engine.editor_hint:
		return
		
		
	var tiles = {
		"Pottery 1":"res://Entities/Objects/Destructibles/DestructiblePottery.tscn",
		"Pottery 2":"res://Entities/Objects/Destructibles/DestructiblePottery.tscn",
		"Pottery 3":"res://Entities/Objects/Destructibles/DestructiblePottery.tscn",
		"Pottery 4":"res://Entities/Objects/Destructibles/DestructiblePottery.tscn",
		"Pottery 5":"res://Entities/Objects/Destructibles/DestructiblePottery.tscn",
		"Pottery 6":"res://Entities/Objects/Destructibles/DestructiblePottery.tscn",
		"Pottery 7":"res://Entities/Objects/Destructibles/DestructiblePottery.tscn",
	}

	for tileName in tiles.keys():
		spawn_objects_from_tilemap(tileName, tiles[tileName])
	
func _get_configuration_warning():
	if ground_tilemap.is_empty():
		return "TilemapToObject tilemap should be provided with another tilemap representing the ground. This allows blocks to fall when they're over an empty tile."
	else:
		return "Tiles Named 'Pottery 1' to 'Pottery 7' will be replaced with DestructiblePottery.tscn"
		

func spawn_objects_from_tilemap(tileName : String, scenePath : String):
	if scenePath != "":
		for cellPos in get_used_cells():
			var cellID = get_cellv(cellPos)
			if cellID in tile_set.get_tiles_ids(): # fix in case a tilemap was previously mapped to a different tileset

				var cellName = tile_set.tile_get_name(cellID)
				if cellName == tileName:
					var newObj = load(scenePath).instance()
					set_cellv(cellPos, -1) # remove the tile
					if newObj.has_method("set_tilemap"):
						newObj.set_tilemap(get_node(ground_tilemap)) # must be a child of another tilemap representing the ground
					add_child(newObj)
					newObj.set_global_position( (map_to_world(cellPos) + obj_offset) * scale )

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

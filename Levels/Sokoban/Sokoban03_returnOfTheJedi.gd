extends "res://Levels/BaseLevel.gd"

export var SokobanCubeOffset = Vector2(0,75)
var coord_list_cubes = []

func _ready():
	SetupSokobanCubes()

func SetupSokobanCubes():
	# reset values
	coord_list_cubes = []
	# iterate through tilemap children
	for child in tileMapLevel1.get_children():
		# check if child sokobanCube
		if "SokobanCube" in child.name:
			# align cube with ground tile underneath
			var coords = get_cube_coord(child)
			var local_pos = tileMapGround.map_to_world(coords)
			var global_pos = tileMapGround.to_global(local_pos)
			child.global_position = global_pos + SokobanCubeOffset
			# connect cube area
			child.area.connect("input_event",self,"cubeClicked",[child])
			# add cube coords to coord list
			coord_list_cubes.append(coords)

func get_cube_coord(cube):
	var local_position = tileMapGround.to_local(cube.global_position)
	var coords = tileMapGround.world_to_map(local_position)
	return coords

func cubeClicked(viewport_, event, shape_,cube):
	# if not clicked return
	if not event.is_action_pressed("shoot"): return
	# check direction player to cube
	var player2cube = cube.global_position - player.global_position
	## check if player close enough
	if player2cube.length()>200: return
	# calc move direction dependend on player2cube angle
	var coords = get_cube_coord(cube)
	####
	var target_coord
	var rel_dir
	if (0<=player2cube.angle()) and (player2cube.angle()<PI/2): #from top left
		target_coord = coords + Vector2(1,0)
		rel_dir = Vector2(256,128)/2
	if PI/2<=player2cube.angle() and player2cube.angle()<PI: #from top right
		target_coord = coords + Vector2(0,1)
		rel_dir = Vector2(-256,128)/2
	if -PI/2<=player2cube.angle() and player2cube.angle()<0: #from bot left
		target_coord = coords + Vector2(0,-1)
		rel_dir = Vector2(256,-128)/2
	if -PI<=player2cube.angle() and player2cube.angle()<-PI/2: #from bot right
		target_coord = coords + Vector2(-1,0)
		rel_dir = Vector2(-256,-128)/2
	## check if SokobanCube is at target coord
	if target_coord in coord_list_cubes: return
	## check if wall is in that direction with test move
	if cube.test_move(cube.transform,rel_dir): return
	## move cube and update coord list
	cube.moveTo(cube.position+rel_dir)
	
	coord_list_cubes.remove(coord_list_cubes.find(coords))
	coord_list_cubes.append(target_coord)



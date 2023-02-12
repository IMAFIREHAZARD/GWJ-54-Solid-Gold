extends Node2D


var player : KinematicBody2D
var current_cube : KinematicBody2D = null

signal pushed_block(block)

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent()

func _unhandled_input(event):
	if Input.is_action_just_pressed("interact"):
		var current_cube = find_nearest_cube()
		print("Found " + current_cube.name)
		
func find_nearest_cube():
	var cubes = get_tree().get_nodes_in_group("SokobanCubes")
	var nearestCube = Global.get_nearest_object(cubes, self)
	if nearestCube != null:
		return nearestCube

func attach_to_sokoban_cube(cube):
	current_cube = cube
	connect("pushed_cube", current_cube, "_on_cube_pushed")
	
	
func detach_from_sokoban_cube(cube):
	disconnect("pushed_cube", current_cube, "_on_cube_pushed")
	
	
	current_cube = null
	
	


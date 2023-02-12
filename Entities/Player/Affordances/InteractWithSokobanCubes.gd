extends Node2D


var player : KinematicBody2D
var current_cube : KinematicBody2D = null
var move_speed = 20.0
var vel = Vector2.ZERO

#warning-ignore:UNUSED_SIGNAL
signal pushed_block(block)

enum States { DISABLED, ACTIVE }
var State = States.DISABLED


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent()

func activate():
	State = States.ACTIVE

func deactivate():
	State = States.DISABLED

func _unhandled_input(_event):
	if Input.is_action_just_pressed("interact"):
		if current_cube == null:
			current_cube = find_nearest_cube()
			if current_cube != null:
				attach_to_sokoban_cube(current_cube)
			print("Found " + current_cube.name)
		else:
			detach_from_sokoban_cube(current_cube)
			current_cube = null
			
func _physics_process(delta):
	if current_cube != null:
		move_with_cube(delta)
		
func move_with_cube(delta):
	if Dialogic.has_current_dialog_node():
		return # pause movement for dialog
		
	var move = Vector2.ZERO
	move = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target_vel = move.normalized() * move_speed
	vel = vel.linear_interpolate(target_vel, delta * 30)
	# warning-ignore:return_value_discarded
	player.move_and_slide(vel * Vector2(1,0.5))
	player.animate_movement(vel)
	
	
	
		
		
func find_nearest_cube():
	var cubes = get_tree().get_nodes_in_group("SokobanCubes")
	var nearestCube = Global.get_nearest_object(cubes, self)
	if nearestCube != null:
		return nearestCube

func attach_to_sokoban_cube(cube):
	current_cube = cube
	#warning-ignore:RETURN_VALUE_DISCARDED
	connect("pushed_cube", current_cube, "_on_cube_pushed")
	
	
func detach_from_sokoban_cube(cube):
	if current_cube == cube:
		disconnect("pushed_cube", current_cube, "_on_cube_pushed")
		current_cube = null
		
	
	


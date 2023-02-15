extends Node2D


var player : KinematicBody2D
var current_cube : KinematicBody2D = null
var move_speed = 200.0
var vel = Vector2.ZERO

var last_print_time : float = 0.0
var polling_interval : float = 1000.0 #milliseconds between print statements
var lookahead_offset = 60.0

#warning-ignore:UNUSED_SIGNAL
signal pushed_cube(cube)

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
			if current_cube != null:
				print("Found ", current_cube.name)
		else:
			detach_from_sokoban_cube(current_cube)
			current_cube = null
	
			
func _physics_process(delta):
#	if AudioSystem.pulse_frame:
#		print("InteractWithSokobanCubes.gd says player.last_direction = ", player.last_direction)
		
	$LookaheadProbeVisualizer.position = player.last_direction.normalized().rotated(0.78) * lookahead_offset + Vector2(0,-16)
	if current_cube != null:
		if is_any_movement_key_pressed():
			move_with_cube(delta)

func is_any_movement_key_pressed():
	var movement_actions = ["move_left", "move_right", "move_up", "move_down"]
	var actionPressed = false
	for action in movement_actions:
		if Input.is_action_pressed(action):
			actionPressed = true
	return actionPressed
	
		
func move_with_cube(delta):
	if is_instance_valid(current_cube) == false:
		detach_from_sokoban_cube(current_cube)
		
		printerr("InteractWithSokobanCubes error - deal with previously freed instances better. TBD")
		return
	
	var printNow : bool = false
	if Time.get_ticks_msec() > last_print_time + polling_interval:
		printNow = true
		last_print_time = Time.get_ticks_msec()
	
	
	# player is attached to a cube.
	# they're not allowed to pull, only push
	# only acceptable direction is the vector between player and cube
	# stepped to Vector2(2,1) intervals
	
	if Dialogic.has_current_dialog_node():
		return # pause movement for dialog
		
	var move = Vector2.ZERO
#	move = Input.get_vector("move_left", "move_right", "move_up", "move_down")
#	#translate to isometric by rotating the move vector then stepifying it to Vector2(2,1)
#	move = move.rotated(PI/4.0)
#	move.y /= 2.0
#	move *= 5.0 # make it closer to the acceptable directions than 0,0
	
	var acceptable_directions = [Vector2(2,1), Vector2(2,-1), Vector2(-2,1), Vector2(-2,-1), Vector2.ZERO ]
	var interaction_direction = global_position.direction_to(current_cube.global_position) * 2.0
	if printNow: print("interaction_direction = " , interaction_direction)

	var closest_direction = Vector2.ZERO
	var closest_distance = 1000000.0
	for acceptable_direction in acceptable_directions:
		var distance = interaction_direction.distance_squared_to(acceptable_direction)
		if distance < closest_distance:
			closest_distance = distance
			closest_direction = acceptable_direction
	move = closest_direction
	if printNow: print("closest_direction = ", closest_direction)
	
	#var target_vel = move.normalized() * move_speed
	#vel = vel.linear_interpolate(target_vel, delta * 30)
	# warning-ignore:return_value_discarded
	player.move_and_collide(move * move_speed * delta)
	player.animate_movement(move * move_speed)
	emit_signal("pushed_cube", move)
	
	
		
		
func find_nearest_cube():
	var cubes = get_tree().get_nodes_in_group("SokobanCubes")
	
	var probePosition = self.global_position + player.last_direction.rotated(PI/4.0).normalized() * lookahead_offset
	$LookaheadProbeVisualizer.global_position = probePosition
	var nearestCube = Global.get_nearest_object(cubes, probePosition)
	if nearestCube != null:
		return nearestCube

func attach_to_sokoban_cube(cube):
	current_cube = cube
	if cube.has_method("activate"):
		cube.activate(self.player) # the affordance or the player?
	#warning-ignore:RETURN_VALUE_DISCARDED
	connect("pushed_cube", current_cube, "_on_cube_pushed")
	player.State = player.States.PUSHING_BLOCK
	
func detach_from_sokoban_cube(cube):
	if current_cube == cube:
		if is_instance_valid(cube) and cube.has_method("deactivate"):
			cube.deactivate(self.player)
		disconnect("pushed_cube", current_cube, "_on_cube_pushed")
		current_cube = null
	player.State = player.States.READY
		
	
	


extends "res://Entities/NPCs/BaseNPC.gd"

var patrolling_path = []
var current_patrolling_index = 0
var state_list = ["patrolling"]

func _ready():
	# setup patrolling path 
	setup_patrolling_path()
	# start patrolling
	start_patrolling()

func setup_patrolling_path():
	# reset path
	patrolling_path = []
	# add path positions to patrolling path
	for child in $PatrollingPath.get_children():
		patrolling_path.append(child.global_position)

func start_patrolling():
	# find nearest point in patrolling path
	var min_dist = 100000
	var min_ind = 0
	for i in len(patrolling_path):
		var pos = patrolling_path[i]
		var dist = global_position.distance_to(pos)
		if dist<min_dist:
			min_dist = dist
			min_ind = i
	# set target_location to nearest position
	nav_agent.set_target_location(patrolling_path[min_ind])
	# set patrolling index
	current_patrolling_index = min_ind
	# check if reachable
	check_target_reachable()

func check_target_reachable():
	if not nav_agent.is_target_reachable():
		current_patrolling_index+=1
		if (current_patrolling_index == len(patrolling_path)): current_patrolling_index = 0
		## set next target_location
		nav_agent.set_target_location(patrolling_path[current_patrolling_index])
		##
		print("A target location wasnt reachable. This is not intended!")

func _physics_process(delta):
	## calc next move
	var move = nav_agent.get_next_location()-global_position;
	# set move speed
	var target_vel = move.normalized() * move_speed  
	# move
	move_and_slide(target_vel)
	## adjust sprite frame dependend on move angle
	var f = round(abs(Vector2.DOWN.angle_to(vel))/deg2rad(45))
	if vel.x < 1:
		animated_sprite.scale.x = 1
	if vel.x > 1:
		animated_sprite.scale.x = -1
	animated_sprite.frame = f
	
	# if target reached select next point in patrolling_path
	if nav_agent.is_target_reached():
		# increment index
		current_patrolling_index+=1
		if (current_patrolling_index == len(patrolling_path)):
			current_patrolling_index = 0
		# select next position
		nav_agent.set_target_location(patrolling_path[current_patrolling_index])
		# check if reachable
		check_target_reachable()
	pass

extends "res://Entities/NPCs/BaseNPC.gd"

var patrolling_path = []
var current_patrolling_index = 0
var state_list = ["patrolling"]

func _ready():
	# setup patrolling path 
	setup_patrolling_path()
	# start patrolling
	

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
	
func _physics_process(delta):
	# if target reached select next point in patrolling_path
	if nav_agent.is_target_reached():
		# increment index
		current_patrolling_index+=1
		if (current_patrolling_index == patrolling_path.count()):
			current_patrolling_index = 0
		# select next position
		nav_agent.set_target_location(patrolling_path[current_patrolling_index])
		
	pass

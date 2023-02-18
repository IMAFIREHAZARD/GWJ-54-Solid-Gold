extends Node


var bpm : float = 90.0

#var gun_curse_taken = false
#var speed_curse_taken = false
#var strength_curse_taken = false

var curses_offered = {
	"gun_hands":false,
	"speed":false,
	"strength":false,
	"levitation":false,
}

var curses_taken = {
	"gun_hands":false,
	"speed":false,
	"strength":false,
	"levitation":false,
}

# increment these values so we can offer curses as required
var scene_attempts = {
	"Shooter":0,
	"BossFight":0,
	"Runner":0,
	"Sokoban":0,
}


var player_max_health : float = 10.0 # each heart represents 2 health
var player_health_remaining : float = player_max_health

var player_events = {
	"falls":0,

}



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset_health():
	player_health_remaining = player_max_health

func reset_curses():
	for curse in curses_taken.keys():
		curses_taken[curse] = false
	
#	gun_curse_taken = false
#	speed_curse_taken = false
#	strength_curse_taken = false
	
	player_health_remaining = player_max_health
	

func is_paused():
	# Wow, this gets called a lot.
	return false
	#return get_tree().paused

func get_num_curses():
#	var count = 0
#	for curse in curses_taken:
#		if curses_taken[curse] == true:
#			count += 1
	var count = curses_taken.values().count(true)
	return count
		

func get_nearest_object(objArray, refObject): # can take a Vector2 or Object2D
	var refPos
	if typeof(refObject) == TYPE_VECTOR2:
		refPos = refObject
	else: # object
		refPos = refObject.global_position
	var nearestDistanceSq = 10000000000000.0
	var nearestObject = null
	for object in objArray:
		var distanceSq = object.global_position.distance_squared_to(refPos)
		if distanceSq < nearestDistanceSq:
			nearestDistanceSq = distanceSq
			nearestObject = object
	return nearestObject

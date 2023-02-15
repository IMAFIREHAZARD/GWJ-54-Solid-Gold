extends Node


var bpm : float = 90.0

#var gun_curse_taken = false
#var speed_curse_taken = false
#var strength_curse_taken = false

var curses_taken = {
	"gun_hands":false,
	"speed":false,
	"strength":false,
}

var player_max_health : float = 5.0
var player_health_remaining : float = player_max_health


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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

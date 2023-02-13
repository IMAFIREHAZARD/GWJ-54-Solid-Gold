extends Node


var bpm : float = 90.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func is_paused():
	# Wow, this gets called a lot.
	return false
	#return get_tree().paused


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

extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BasicReflector_area_entered(area):
	if area.is_in_group("projectiles"):
		reflect(area)


func reflect(object):
	# This works great for static reflectors,
	# but it's unreliable when the reflection surface is moving???
	
	var incomingVector = object.transform.x.normalized()
	
	
	#var normalVector = self.transform.x.normalized()
	var normalVector = Vector2.RIGHT.rotated(self.global_rotation)
	
	var mirrorLine = normalVector.rotated(PI/2.0)
	var reflectionVector = incomingVector.reflect(mirrorLine.normalized())
	#var reflectionVector = incomingVector - 2 * normalVector * incomingVector.dot(normalVector)
	
	object.rotate(reflectionVector.angle())
	
	# let the bullets hit the player
	object.set_collision_mask_bit(0, true)

	
	

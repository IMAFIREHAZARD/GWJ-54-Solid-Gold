extends KinematicBody2D


var speed = 550.0
var velocity = Vector2.LEFT * speed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#warning-ignore:RETURN_VALUE_DISCARDED
	move_and_slide(velocity)

func fly():
	$FlyingSprite.show()
	$WalkingSprite.hide()

func walk():
	$WalkingSprite.show()
	$FlyingSprite.hide()

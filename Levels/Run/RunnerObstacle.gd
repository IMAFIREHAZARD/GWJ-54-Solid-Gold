extends KinematicBody2D


export var speed = 550.0
export var curse_speed_multiplier = 1.5
var velocity : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.speed_curse_taken:
		speed *= curse_speed_multiplier
	velocity = Vector2.LEFT * speed
	
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

func hit():
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("hit")
	# animation player will call queue_free() directly



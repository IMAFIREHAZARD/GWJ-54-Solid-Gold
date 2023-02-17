extends KinematicBody2D


export var speed = 750.0

var velocity : Vector2 = Vector2.ZERO
var walking : bool = false
var flying : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#velocity = Vector2.LEFT * speed
	pass

func set_velocity(speed_multiplier):
	velocity = Vector2.LEFT * speed * speed_multiplier
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#warning-ignore:RETURN_VALUE_DISCARDED
	move_and_slide(velocity)

func fly(speed_multiplier):
	$FlyingSprite.show()
	$WalkingSprite.hide()
	set_velocity(speed_multiplier)
	flying = true

func walk(speed_multiplier):
	$WalkingSprite.show()
	$FlyingSprite.hide()
	set_velocity(speed_multiplier)
	walking = true

func hit():
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("hit")
	# animation player will call queue_free() directly

func explode():
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()


func _on_ExitZone_body_entered(body):
	print("Pearly Gates Exit Reached")
	

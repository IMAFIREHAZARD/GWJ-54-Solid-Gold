extends Node2D


export var speed = 550.0
var speed_multiplier = 1.0
var velocity : Vector2 = Vector2.LEFT * speed * speed_multiplier
export var next_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_velocity(speedMultiplier):
	velocity = Vector2.LEFT * speed * speedMultiplier
	speed_multiplier = speedMultiplier
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta


func _on_ExitZone_body_entered(body):
	if body.name == "Player":
		StageManager.change_scene_to(next_scene)

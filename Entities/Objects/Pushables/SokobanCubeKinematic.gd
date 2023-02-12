extends KinematicBody2D

enum States { IDLE, MOVING }
var State = States.IDLE

var pusher : KinematicBody2D
var speed : float = 100.0
	
export var cardinal_directions_only : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if State == States.MOVING:
		# figure out which way the player is pushing you
		# move away if the player gets closer
		var direction = get_direction(pusher)
	
		var separation_required = 50.0
		if pusher.global_position.distance_squared_to(self.global_position) < separation_required * separation_required:
			#warning-ignore:RETURN_VALUE_DISCARDED
			#move_and_slide(direction * speed)
			position += direction * speed * _delta

func get_direction(pushingSource):
	var direction
	direction = pusher.global_position.direction_to(self.global_position)

	if cardinal_directions_only:
		if direction.x < 0.0:
			direction.x = -2.0
		else:
			direction.x = 2.0
		if direction.y < 0.0:
			direction.y = -1.0
		else:
			direction.y = 1.0
			
	return direction


func _on_PlayerPushRadius_body_entered(body):
	if body.name == "Player" and State == States.IDLE:
		$SpriteWhiteCube.visible = true
		State = States.MOVING
		pusher = body


func _on_PlayerPushRadius_body_exited(body):
	if body.name == "Player" and State == States.MOVING:
		$SpriteWhiteCube.visible = false
		State = States.IDLE

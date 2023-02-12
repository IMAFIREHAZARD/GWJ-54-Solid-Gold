extends KinematicBody2D

enum States { IDLE, MOVING, FALLING }
var State = States.IDLE

var pusher : KinematicBody2D
var speed : float = 100.0

var falling_velocity : Vector2 = Vector2.ZERO
var gravity = 98.0
	
export var cardinal_directions_only : bool = true
export var ground_tilemap : NodePath

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if State == States.MOVING:
		# figure out which way the player is pushing you
		# move away if the player gets closer
		var direction = get_direction(pusher)
	
		var separation_required = 50.0
		if pusher.global_position.distance_squared_to(self.global_position) < separation_required * separation_required:
			#warning-ignore:RETURN_VALUE_DISCARDED
			#move_and_slide(direction * speed)
			if is_clear(direction):
				position += direction * speed * delta
	elif State == States.FALLING:
		fall(delta)


func is_clear(direction):
	var distance = 12.0
	$RayCast2D.cast_to = direction * distance
	$Line2D.points = [$RayCast2D.position, $RayCast2D.position + $RayCast2D.cast_to]
	if $RayCast2D.is_colliding():
		return false
	else:
		return true


func fall(delta):
	var direction = Vector2.DOWN
	falling_velocity += direction * delta * gravity
	position += falling_velocity
	if is_outside_frustum():
		queue_free()

func is_outside_frustum():
	var screen_size = get_viewport_rect().size
	var my_position = global_position
	if my_position.x < 0 or my_position.x > screen_size.x or my_position.y < 0 or my_position.y > screen_size.y:
		return true
	else:
		return false
	

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


func get_tile_underneath():
	var my_tilemap : TileMap = get_node(ground_tilemap)
	var local_position = my_tilemap.to_local(global_position)
	var map_position = my_tilemap.world_to_map(local_position)
	var tileSet = my_tilemap.tile_set
	var tileID = my_tilemap.get_cellv(map_position)
	if tileID != -1:
		var tileName = tileSet.tile_get_name(tileID)
		return tileName
	else:
		return "Void"

func _on_PlayerPushRadius_body_entered(body):
	if body.name == "Player" and State == States.IDLE:
		$SpriteWhiteCube.visible = true
		State = States.MOVING
		pusher = body


func _on_PlayerPushRadius_body_exited(body):
	if body.name == "Player" and State == States.MOVING:
		$SpriteWhiteCube.visible = false
		State = States.IDLE


func _on_PollingTimer_timeout():
	if State == States.MOVING:
		var tileName = get_tile_underneath()
		if tileName == "Void":
			State = States.FALLING
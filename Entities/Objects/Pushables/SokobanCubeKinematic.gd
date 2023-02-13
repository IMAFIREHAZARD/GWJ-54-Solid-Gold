extends KinematicBody2D

enum States { IDLE, ACTIVATED, MOVING, FALLING, DEAD }
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
	$Label.text = States.keys()[State]
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
	State = States.FALLING
	var direction = Vector2.DOWN
	falling_velocity += direction * delta * gravity
	position += falling_velocity
	if is_outside_frustum():
		State = States.DEAD
		queue_free()

func is_outside_frustum():
	var screen_size = get_viewport_rect().size
	var my_position = global_position
	if my_position.x < 0 or my_position.x > screen_size.x or my_position.y < 0 or my_position.y > screen_size.y:
		return true
	else:
		return false
	

func get_direction(pushingSource):
	
	if is_instance_valid(self) and is_instance_valid(pushingSource):
		var direction
		direction = pushingSource.get_global_position().direction_to(self.global_position)

		#translate direction to cardinal directions on isometric grid, no diagonals
		var aceptable_directions = [ Vector2(2, 1), Vector2(2, -1), Vector2(-2, -1), Vector2(-2, 1), Vector2.ZERO]
		var closest_direction = Vector2.ZERO
		var closest_distance = 1000000.0
		for acceptable_direction in aceptable_directions:
			var distance = direction.distance_squared_to(acceptable_direction)
			if distance < closest_distance:
				closest_distance = distance
				closest_direction = acceptable_direction
		return closest_direction





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
	if State == States.IDLE:
		var affordanceName = "InteractWithSokobanCubes"
		if body.has_method("has_affordance") and body.has_affordance(affordanceName) != null:
			#warning-ignore:UNUSED_VARIABLE
			var affordance = body.get_affordance(affordanceName)
			pass # TBD
	
			$SpriteWhiteCube.visible = true
			State = States.ACTIVATED
			# not moving until player presses interact key
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

func _on_cube_pushed(direction): # signal from player/affordances
	if is_clear(direction) and State == States.ACTIVATED:
		move_and_slide(direction * speed)
	

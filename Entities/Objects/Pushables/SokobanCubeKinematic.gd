extends KinematicBody2D

enum States { IDLE, ACTIVATED, MOVING, FALLING, DEAD }
var State = States.IDLE

var player
var mouse_hovering : bool = false
var player_nearby : bool = false

var pusher : KinematicBody2D # the player object, not the player's affordance node
var speed : float = 100.0
const move_dist = 35.7771 # Good old Pythagoras ... sqrt((2xrect.w)^2 + (rect.h)^2)

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
	if my_tilemap == null:
		my_tilemap = find_node("*Ground")

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
		if body.name == "Player":
			wiggle()
			player = body
			player_nearby = true

func wiggle():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", scale * 1.1, 0.25).set_ease(Tween.EASE_IN)
	tween.tween_interval(0.15)
	tween.tween_property(self, "scale", Vector2.ONE, 0.25).set_ease(Tween.EASE_OUT)
	
func activate(requestingBody):
	if State == States.IDLE:
		$SpriteWhiteCube.visible = true
		State = States.ACTIVATED
		# not moving until player presses interact key
		pusher = requestingBody # probably player
		
func deactivate(requestingBody):
	if pusher == requestingBody:
		State = States.IDLE
		$SpriteWhiteCube.hide()
		

func _on_PlayerPushRadius_body_exited(body):
	if body.name == "Player":
		wiggle()
		player_nearby = false


func _on_PollingTimer_timeout():
	if State == States.MOVING:
		var tileName = get_tile_underneath()
		if tileName == "Void":
			State = States.FALLING

func move_to(destination):
	State = States.MOVING
	var tween = create_tween()
	tween.tween_property(self, "position", position + destination, 0.3)
	yield(tween, "finished")
	State = States.ACTIVATED

func _on_cube_pushed(direction): # signal from player/affordances
	if is_clear(direction) and State == States.ACTIVATED:
		move_to(direction * move_dist)
		#move_and_slide(direction * speed)
	
func _on_cube_clicked(direction):
	if is_clear(direction) and player_nearby:
		move_to(direction * move_dist)
		
		#var distance = 50.0 * speed
		#warning-ignore:RETURN_VALUE_DISCARDED
		#move_and_slide(direction * distance)


func _unhandled_input(_event):

	if player_nearby and Input.is_action_just_pressed("push"):
		if State == States.ACTIVATED:
			print("clicked Sokoban Cube")
			_on_cube_clicked(player.get_global_position().direction_to(self.global_position))
			get_tree().set_input_as_handled()

#	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
#		if $Sprite.get_rect().has_point($Sprite.to_local(event.position)):
#			print("clicked Sokoban Cube")
#			_on_cube_clicked(player.get_global_position().direction_to(self.global_position))
		

func _on_SokobanCubeKinematic_mouse_entered():
	mouse_hovering = true

func _on_SokobanCubeKinematic_mouse_exited():
	mouse_hovering = false
	

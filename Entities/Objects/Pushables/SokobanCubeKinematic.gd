extends KinematicBody2D

enum States { IDLE, ACTIVATED, MOVING, FALLING, DEAD }
var State = States.IDLE

var player
var mouse_hovering : bool = false
var player_nearby : bool = false

var pusher : KinematicBody2D # the player object, not the player's affordance node
var speed : float = 100.0
var move_dist = 71
var current_direction : Vector2

var falling_velocity : Vector2 = Vector2.ZERO
var gravity = 98.0
	

export var cardinal_directions_only : bool = true
var ground_tilemap : TileMap



# Called when the node enters the scene tree for the first time.
func _ready():
	setup_push_zones()
	
	$SpriteWhiteCube.hide()
	set_move_dist()
	var timer = get_tree().create_timer(0.5)
	yield(timer, "timeout")
	if ground_tilemap == null:
		ground_tilemap = find_node("*Groun*")
	if ground_tilemap == null:
		printerr("SokobanCubeKinematic.gd needs a tilemap set. Defaulting to get_parent()")
		if get_parent().is_class("TileMap"):
			ground_tilemap = get_parent()

func setup_push_zones():
	for zone in $PushZones.get_children():
		zone.connect("player_entered", self, "_on_push_zone_player_entered")
	
func set_move_dist():
	# pythagoras
	var x = $Sprite.get_rect().size.x / 2.0 * global_scale.x 
	var y = $Sprite.get_rect().size.y / 4.0 * global_scale.y
	var hypoteneuse = sqrt(x*x + y*y)
	#print("pythagoras says: ", hypoteneuse, " but we're setting it to 71 because the ruler tool measured that.")
	move_dist = hypoteneuse / 2.0 # why /2???

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if State == States.MOVING:
		# figure out which way the player is pushing you
		# move away if the player gets closer
		var direction = current_direction
	
		var separation_required = 50.0
		if pusher.global_position.distance_squared_to(self.global_position) < separation_required * separation_required:
			#warning-ignore:RETURN_VALUE_DISCARDED
			#move_and_slide(direction * speed)
			if is_clear(direction):
				position += direction * speed * delta
	elif State == States.FALLING:
		fall(delta)


func is_clear(direction):
	var distance = move_dist
	$RayCast2D.cast_to = direction * distance
	$Line2D.points = [$RayCast2D.position, $RayCast2D.position + $RayCast2D.cast_to]
	if $RayCast2D.is_colliding():
		return false
	else:
		return true

func set_tilemap(groundTilemap):
	ground_tilemap = groundTilemap

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
	

#func get_direction(pushingSource):
#
#	if is_instance_valid(self) and is_instance_valid(pushingSource):
#		var direction
#		direction = pushingSource.get_global_position().direction_to(self.global_position)
#
#		#translate direction to cardinal directions on isometric grid, no diagonals
#		var aceptable_directions = [ Vector2(2, 1), Vector2(2, -1), Vector2(-2, -1), Vector2(-2, 1), Vector2.ZERO]
#		var closest_direction = Vector2.ZERO
#		var closest_distance = 1000000.0
#		for acceptable_direction in aceptable_directions:
#			var distance = direction.distance_squared_to(acceptable_direction)
#			if distance < closest_distance:
#				closest_distance = distance
#				closest_direction = acceptable_direction
#		return closest_direction






func get_tile_underneath():
	var my_tilemap = ground_tilemap
	if ground_tilemap == null:
		return
		
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
			print("cube is falling. Why?")
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
	


func _on_PlayerOccludedArea_body_entered(body):
	if body.name == "Player":
		set_self_modulate(Color(1,1,1,0.5))


func _on_PlayerOccludedArea_body_exited(body):
	if body.name == "Player":
		set_self_modulate(Color.white)

func _on_push_zone_player_entered(directionVector):
	current_direction = directionVector

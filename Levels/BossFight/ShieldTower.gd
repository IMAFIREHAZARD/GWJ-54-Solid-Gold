extends StaticBody2D

export(Array, NodePath) var box_sensors
export(Array, NodePath) var direction_sensors
var directionObjs : Array
export(PackedScene) var bug_scene
var shield_power = 0

enum tower_types {
	SHIELD,
	SPAWNER,
	SHOOTER,
}

export (tower_types) var tower_type = tower_types.SHIELD
export var projectile_scene : PackedScene


enum {
	REFLECT,
	SPAWN
}

var state = SPAWN setget _set_state

func _ready() -> void:
	for path in box_sensors:
		shield_power += 1
		var sensor = get_node(path) as BoxSensor
		sensor.connect("block_entered", self, "decrease_shield_power")
		sensor.connect("block_exited", self, "increase_shield_power")
	for path in direction_sensors:
		var sensor = get_node(path)
		if sensor != null and is_instance_valid(sensor):
			directionObjs.append(sensor)

func decrease_shield_power():
	shield_power -= 1
	if shield_power <= 0:
		self.state = SPAWN

func increase_shield_power():
	shield_power += 1
	if shield_power > 0:
		self.state = REFLECT

func get_direction():
	if directionObjs.size() == 0:
		return 0
	else:
		var directionInt = sequence_to_int(directionObjs)
		var directionRad = directionInt/8.0 * (2 * PI)
		#print("directionObjs: ", directionObjs)
		#print("direction == ", directionInt)
		#print("in radians == ", directionRad)
		
		return directionRad
	
#
#	var directionInt : int = 0
#	var direction_bits
#	var directionRadians : float = 2.0*PI
#
#	for sensorIndex in range(direction_sensors.size()): # 0, 1, 2
#		var currentBitValue : int = 0
#		if get_node(direction_sensors[sensorIndex]).active:
#			if sensorIndex == 0:
#				currentBitValue = 1
#			elif sensorIndex == 1:
#				currentBitValue = 2
#			else:
#				currentBitValue = pow(2,sensorIndex)
#
#			print("bit " , sensorIndex , ', value ', currentBitValue)
#			directionInt += currentBitValue
#	print("directionInt == ", directionInt)
#
#	if directionInt == 0:
#		directionRadians = 0.0
#	else:
#		directionRadians = 2.0*PI / directionInt
#	print("Tower Direction in int == ", directionInt)
#	print("Tower Direction in rad == ", directionRadians)
#
#	return directionRadians

func sequence_to_int(sequence: Array) -> int:
	var result = 0
	for i in range(sequence.size()):
		if sequence[i].active:
			result += 1 << i
	return result

func _set_state(value):
	state = value
	$Shield.visible = state == REFLECT
	$Reflector.monitoring = state == REFLECT

func _on_Timer_timeout() -> void:
	if tower_type == tower_types.SHIELD:
		if StageManager.current_map.current_bugs < StageManager.current_map.max_tower_bugs\
		and state == SPAWN:
			var bug = bug_scene.instance()
			get_parent().add_child(bug)
			bug.global_position = global_position + Vector2(randf() * 100, 0).rotated(TAU * randf())
	elif tower_type == tower_types.SHOOTER:
		var newDirVector = Vector2.RIGHT.rotated(get_direction())
		var isoDirVector = top_to_iso(newDirVector)
		
		$DirectionViz/Arrow.points = [Vector2.ZERO, isoDirVector]

		spawn_projectile(isoDirVector)

func spawn_projectile(directionVector):
	var newProjectile = projectile_scene.instance()
	if newProjectile.get("travel_dir") != null:
		newProjectile.travel_dir = directionVector
	else:
		newProjectile.rotation = directionVector.angle()
	add_child(newProjectile)
	#newProjectile.rotation = projectileRotation

	newProjectile.global_position = $DirectionViz.global_position


func top_to_iso(vector : Vector2):
	return Vector2(vector.x, vector.y / 2.0)

func _on_Reflector_reflect() -> void:
	var _tween = create_tween().tween_property($Shield, "modulate", Color.white, 0.2).from(Color(2,2,2))


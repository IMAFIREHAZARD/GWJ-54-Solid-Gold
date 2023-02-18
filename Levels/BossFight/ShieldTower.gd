extends StaticBody2D

export(Array, NodePath) var box_sensors
export(Array, NodePath) var direction_sensors
export(PackedScene) var bug_scene
var shield_power = 0

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

func decrease_shield_power():
	shield_power -= 1
	if shield_power <= 0:
		self.state = SPAWN

func increase_shield_power():
	shield_power += 1
	if shield_power > 0:
		self.state = REFLECT

func get_direction():
	if direction_sensors.size() == 0:
		return 0
	
	var directionInt : int = 0
	var direction_bits
	var directionRadians : float = 2.0*PI
	
	for sensorIndex in range(direction_sensors.size()): # 0, 1, 2
		var currentBitValue : int = 0
		if get_node(direction_sensors[sensorIndex]).active:
			if sensorIndex == 0:
				currentBitValue = 1
			elif sensorIndex == 1:
				currentBitValue = 2
			else:
				currentBitValue = pow(2,sensorIndex)

			print("bit " , sensorIndex , ', value ', currentBitValue)
			directionInt += currentBitValue
	print("directionInt == ", directionInt)
	
	if directionInt == 0:
		directionRadians = 0.0
	else:
		directionRadians = 2.0*PI / directionInt
	print("Tower Direction in int == ", directionInt)
	print("Tower Direction in rad == ", directionRadians)

	return directionRadians


func _set_state(value):
	state = value
	$Shield.visible = state == REFLECT
	$Reflector.monitoring = state == REFLECT

func _on_Timer_timeout() -> void:
	if StageManager.current_map.current_bugs < StageManager.current_map.max_tower_bugs\
	and state == SPAWN:
		var bug = bug_scene.instance()
		get_parent().add_child(bug)
		bug.global_position = global_position + Vector2(randf() * 100, 0).rotated(TAU * randf())
	if "Projectile" in name:
		
		$DirectionViz/Arrow.rotation = get_direction()
		#$DirectionViz/Arrow.scale.y = 0.5

func _on_Reflector_reflect() -> void:
	create_tween().tween_property($Shield, "modulate", Color.white, 0.2).from(Color(2,2,2))


extends StaticBody2D

export(Array, NodePath) var box_sensors
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


func _on_Reflector_reflect() -> void:
	create_tween().tween_property($Shield, "modulate", Color.white, 0.2).from(Color(2,2,2))

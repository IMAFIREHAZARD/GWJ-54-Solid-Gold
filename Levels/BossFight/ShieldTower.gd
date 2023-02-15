extends StaticBody2D

export(Array, NodePath) var box_sensors
var shield_power = 0

func _ready() -> void:
	for path in box_sensors:
		shield_power += 1
		var sensor = get_node(path) as BoxSensor
		sensor.connect("block_entered", self, "decrease_shield_power")
		sensor.connect("block_exited", self, "increase_shield_power")

func decrease_shield_power():
	shield_power -= 1
	if shield_power <= 0:
		$Shield.hide()

func increase_shield_power():
	shield_power += 1
	if shield_power > 0:
		$Shield.show()

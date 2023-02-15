extends Line2D

export(NodePath) onready var box_sensor = get_node(box_sensor) as BoxSensor

func _ready() -> void:
	box_sensor.connect("block_entered", self, "light_up")
	box_sensor.connect("block_exited", self, "dim")

func light_up():
	default_color = Color.greenyellow

func dim():
	default_color = Color(0.1, 0.1, 0.1)

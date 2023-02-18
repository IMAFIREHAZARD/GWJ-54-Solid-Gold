class_name BoxSensor extends Area2D

export var active : bool = false

signal block_entered()
signal block_exited()

func _ready():
	var timer = get_tree().create_timer(0.5)
	yield(timer, "timeout")
	_delayed_ready()

func _delayed_ready():
	active = false
	for body in get_overlapping_bodies():
		if body is PushBlock:
			active = true

		

func _on_BoxSensor_body_entered(body: Node) -> void:
	print(body)
	if body is PushBlock:
		emit_signal("block_entered")
		active = true


func _on_BoxSensor_body_exited(body: Node) -> void:
	
	if body is PushBlock:
		emit_signal("block_exited")
		active = false

func _process(delta):
	$StateLabel.text = "bit: " + str(get_position_in_parent() + 1) + " == " + str(active)
		

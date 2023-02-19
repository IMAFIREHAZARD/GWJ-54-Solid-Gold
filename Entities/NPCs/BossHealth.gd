extends Node2D

onready var boss = get_parent()


# Called when the node enters the scene tree for the first time.
#func _ready():
#	boss = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var num_hearts_remaining = boss.health / boss.health_max * get_child_count()

	for heart in get_children():
		if heart.get_position_in_parent() < num_hearts_remaining:
			heart.set_self_modulate(Color.aquamarine)
		else:
			heart.set_self_modulate(Color(0.2, 0.2, 0.2))

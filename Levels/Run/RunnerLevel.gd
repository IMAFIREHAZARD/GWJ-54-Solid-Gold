extends Node2D

export var next_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Timer/Label.text = str(round($Timer/ExitTimer.time_left))

func introduce_obstacle():
	var obstacle = preload("res://Levels/Run/RunnerObstacle.tscn").instance()
	add_child(obstacle)
	var randSpawner = $ObstacleSpawns.get_children()[randi()%$ObstacleSpawns.get_child_count()]
	obstacle.global_position = randSpawner.global_position
	

func _on_Timer_timeout():
	introduce_obstacle()


func _on_ExitTimer_timeout():
	StageManager.change_scene_to(next_scene)

extends Node2D

export var endless_runner : bool = false

export var next_scene : PackedScene
export var duration : float = 5.0

var bargain_offered : bool = false

var speed_multiplier = 1.0

#signal accept_curse()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer/ExitTimer.set_wait_time(duration)
	

func offer_devils_bargain():
	$ObstacleSpawnTimer.set_paused(true)
	spawn_dialog("SpeedUp")

func _on_dialogic_signal(param):
	if param == "complete_level":
		StageManager.change_scene_to(next_scene)
	elif param == "restart_level":
		Global.reset_curses()
		StageManager.restart_current_level()
		
	elif param == "speed_up":
		speed_up()
	elif param == "do_not_speed_up":
		Global.speed_curse_taken = false
	$ObstacleSpawnTimer.set_paused(false)
	$Timer/ExitTimer.start()
	
	
func speed_up():
	Global.speed_curse_taken = true
	if endless_runner:
		speed_multiplier += 0.25
	else:
		speed_multiplier += 1.0
	$Floor/Sprite.speed_up(speed_multiplier)
	$PlayerSideView.speed_up(speed_multiplier)
	for layer in $Background.get_children():
		if layer.has_method("speed_up"):
			layer.speed_up(speed_multiplier)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Timer/Label.text = str(round($Timer/ExitTimer.time_left))

func introduce_obstacle():
	var obstacle = preload("res://Levels/Run/RunnerObstacle.tscn").instance()
	add_child(obstacle)
	var randSpawner = $ObstacleSpawns.get_children()[randi()%$ObstacleSpawns.get_child_count()]
	obstacle.global_position = randSpawner.global_position
	if randSpawner.name == "Walk" and obstacle.has_method("walk"):
		obstacle.walk(speed_multiplier)
	elif randSpawner.name == "Fly" and obstacle.has_method("fly"):
		obstacle.fly(speed_multiplier)

func _on_Timer_timeout():
	introduce_obstacle()


func resume():
	$Timer/ExitTimer.start()
	$ObstacleSpawnTimer.set_paused(false)

func _on_ExitTimer_timeout():
	
	if bargain_offered == false:
		offer_devils_bargain()
		bargain_offered = true
	elif endless_runner:
		if Global.speed_curse_taken:
			speed_up()
		resume()
	else: # exit
		$Timer/ExitTimer.stop()
		$ObstacleSpawnTimer.stop()

		if Global.speed_curse_taken:
			spawn_dialog("EnjoySpeed")
		else:
			StageManager.change_scene_to(next_scene)
		
		


func spawn_dialog(dialogName : String):
	var new_dialog = Dialogic.start(dialogName)
	add_child(new_dialog)
	new_dialog.connect("dialogic_signal", self, "_on_dialogic_signal")


func _on_runner_died():
	spawn_dialog("PlayerDied")
	$Timer/ExitTimer.stop()
	$ObstacleSpawnTimer.stop()

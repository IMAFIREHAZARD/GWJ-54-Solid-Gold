extends Node2D

export var endless_runner : bool = false

export var next_scene : PackedScene
export var distance_to_run : float = 800.0
export var time_to_cover_distance : float = 60.0

var distance_remaining := distance_to_run

var bargain_offered : bool = false

var speed_multiplier = 1.0

#signal accept_curse()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer/ExitTimer.set_wait_time(time_to_cover_distance / speed_multiplier /2.0)
	
func offer_devils_bargain():
	halt_movement()
	destroy_obstacles()
	spawn_dialog("SpeedUp")

func halt_movement():
	$ObstacleSpawnTimer.set_paused(true)
	
	$Floor/Sprite.speed_up(0)
	$Player.stop()
	for layer in $Background.get_children():
		if layer.has_method("speed_up"):
			layer.speed_up(0)

func resume_movement():
	$Floor/Sprite.speed_up(speed_multiplier)
	$Player.start()
	for layer in $Background.get_children():
		if layer.has_method("speed_up"):
			layer.speed_up(speed_multiplier)
	$ObstacleSpawnTimer.set_paused(false)
	$Timer/ExitTimer.start()
	$Player.start()
	

func _on_dialogic_signal(param):
	if param == "complete_level":
		StageManager.change_scene_to(next_scene)
	elif param == "restart_level":
		Global.reset_curses()
		StageManager.restart_current_level()
		
	elif param == "speed_up":
		resume_movement()
		speed_up()
	elif param == "do_not_speed_up":
		Global.curses_taken["speed"] = false
		resume_movement()
	
	
func speed_up():
	Global.curses_taken["speed"] = true
	if endless_runner:
		speed_multiplier += 0.25
	else:
		speed_multiplier += 1.0
	for child in $Floor.get_children():
		if child.has_method("speed_up"):
			child.speed_up(speed_multiplier)
	#$Floor/Sprite.speed_up(speed_multiplier)
	$Player.speed_up(speed_multiplier)
	for layer in $Background.get_children():
		if layer.has_method("speed_up"):
			layer.speed_up(speed_multiplier)
	
	$Camera2D.speed_up()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Timer/Label.text = "Distance Remaining: " + str(2.0 * distance_remaining/time_to_cover_distance * ($Timer/ExitTimer.time_left)).pad_decimals(2) + "m "

func introduce_obstacle():
	var obstacle = preload("res://Levels/Run/RunnerObstacle.tscn").instance()
	
	var randSpawner = $ObstacleSpawns.get_children()[randi()%$ObstacleSpawns.get_child_count()]
	randSpawner.add_child(obstacle)
	obstacle.global_position = randSpawner.global_position
	if randSpawner.name == "Walk" and obstacle.has_method("walk"):
		obstacle.walk(speed_multiplier)
	elif randSpawner.name == "Fly" and obstacle.has_method("fly"):
		obstacle.fly(speed_multiplier)

func destroy_obstacles():
	for spawner in $ObstacleSpawns.get_children():
		for active_obstacle in spawner.get_children():
			if active_obstacle.has_method("explode"):
				active_obstacle.explode()

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
		if Global.curses_taken["speed"] == true:
			speed_up()
		resume()
	else: # exit
		$Timer/ExitTimer.stop()
		$ObstacleSpawnTimer.stop()
		spawn_exit()
		


#func unnecessary_leftover():
#		if Global.curses_taken["speed"] == true:
#			destroy_obstacles()
#			spawn_dialog("EnjoySpeed")
#		else:
#			StageManager.change_scene_to(next_scene)

func spawn_exit():
	var exit = load("res://Levels/Run/PearlyGatesSideView.tscn").instance()
	
	add_child(exit)
	exit.set_global_position($ObstacleSpawns/Walk.global_position)
	exit.set_velocity(speed_multiplier)
		


func spawn_dialog(dialogName : String):
	var new_dialog = Dialogic.start(dialogName)
	add_child(new_dialog)
	new_dialog.connect("dialogic_signal", self, "_on_dialogic_signal")


func _on_runner_died():
	spawn_dialog("PlayerDied")
	$Timer/ExitTimer.stop()
	$ObstacleSpawnTimer.stop()

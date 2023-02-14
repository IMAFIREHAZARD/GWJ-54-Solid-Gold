extends Node2D

export var next_scene : PackedScene
export var duration : float = 5.0
export (String, "TimelineDropdown") var timeline

var bargain_offered : bool = false


#signal accept_curse()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer/ExitTimer.set_wait_time(duration)
	

func offer_devils_bargain():
	$ObstacleSpawnTimer.set_paused(true)
	var new_dialog = Dialogic.start(timeline)
	add_child(new_dialog)
	new_dialog.connect("dialogic_signal", self, "_on_dialogic_signal")

func _on_dialogic_signal(param):
	if param == "restart_level":
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
	$Floor/Sprite.speed *= 2.0
	# PlayerSideView will handle it's own speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Timer/Label.text = str(round($Timer/ExitTimer.time_left))

func introduce_obstacle():
	var obstacle = preload("res://Levels/Run/RunnerObstacle.tscn").instance()
	add_child(obstacle)
	var randSpawner = $ObstacleSpawns.get_children()[randi()%$ObstacleSpawns.get_child_count()]
	obstacle.global_position = randSpawner.global_position
	if randSpawner.name == "Walk" and obstacle.has_method("walk"):
		obstacle.walk()
	elif randSpawner.name == "Fly" and obstacle.has_method("fly"):
		obstacle.fly()

func _on_Timer_timeout():
	introduce_obstacle()


func _on_ExitTimer_timeout():
	
	if bargain_offered == false:
		offer_devils_bargain()
		bargain_offered = true
	else:
		StageManager.change_scene_to(next_scene)

func _on_runner_died():
	var new_dialog = Dialogic.start("PlayerDied")
	add_child(new_dialog)
	new_dialog.connect("dialogic_signal", self, "_on_dialogic_signal")
	$Timer/ExitTimer.stop()
	$ObstacleSpawnTimer.stop()

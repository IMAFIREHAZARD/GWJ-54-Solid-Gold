extends "res://Levels/BaseLevel.gd"

var current_bugs = 0
var boss_dead : bool = false

export var max_bugs = 3 # dictates when bugs stop duplicating
export var max_tower_bugs = 10 # dictates when bugs stop spawning

onready var shield_tower: StaticBody2D = $"%ShieldTower"
onready var shield_tower_2: StaticBody2D = $"%ShieldTower2"
onready var projectile_tower_1 = $"CameraPositions/CameraPosition2"
onready var boss: Sprite = $YSort/BossRoot/pos/Boss

func _ready() -> void:
	player.set_physics_process(false)
	player.set_process_unhandled_input(false)
	yield(do_cutscene(), "completed")
	#start_active_play()
	boss.find_node("AttackTimer").start()
	player.set_physics_process(true)
	player.set_process_unhandled_input(true)
	
	tileMapGround = $YSort/WallsAndGround/Ground
	
func do_cutscene() -> void:
	player.shoot_disabled = true
	player.pause()
	$YSort/Player/AnimationPlayer2.play("WalkIn")
	yield($YSort/Player/AnimationPlayer2, "animation_finished")
	yield(get_tree().create_timer(0.5), "timeout")
	yield(pan_camera(boss.global_position), "completed")
	var dialog = spawn_dialog("BossIntro")
	yield(dialog, "dialogic_signal")
	pan_camera(shield_tower_2.global_position)
	yield(dialog, "dialogic_signal")
	pan_camera(projectile_tower_1.global_position)
	yield(dialog, "dialogic_signal")
	
	yield(pan_camera(player.global_position), "completed")
	start_active_play()
	
func start_active_play():
	player.shoot_disabled = false
	player.resume()
	

func pan_camera(target : Vector2, time := 1.0):
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(cam, "global_position", target, time)
	yield(tween, "finished")

func destroy_all_critters():
	var critters = get_tree().get_nodes_in_group("critters")
	for critter in critters:
		critter.queue_free()


	
		


func _on_boss_dying():
	boss_dead = true

	destroy_all_critters()
	var myBoss = $YSort/BossRoot
	#pan_camera(myBoss.global_position)
	var offset = Vector2.UP * 200.0
	yield(pan_camera(myBoss.global_position + offset), "completed")


#	var camera = find_node("Camera*")
#	if camera != null:
##		remove_child(camera)
##		get_parent().add_child(camera)
#		camera.current = true
#		camera.global_position = StageManager.player.global_position
#		var tween = get_tree().create_tween()
#		var offset = Vector2.UP * 200.0
#		tween.tween_property(camera, "global_position", myBoss.global_position + offset, 1.0 ).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)


func _on_boss_died():
	pass

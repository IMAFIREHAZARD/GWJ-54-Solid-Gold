extends "res://Levels/BaseLevel.gd"

var current_bugs = 0
var max_bugs = 3
onready var shield_tower: StaticBody2D = $"%ShieldTower"
onready var shield_tower_2: StaticBody2D = $"%ShieldTower2"
onready var boss: Sprite = $YSort/BossRoot/pos/Boss

func _ready() -> void:
	player.set_physics_process(false)
	player.set_process_unhandled_input(false)
	yield(do_cutscene(), "completed")
	boss.get_node("Timer").start()
	player.set_physics_process(true)
	player.set_process_unhandled_input(true)

func do_cutscene() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	yield(pan_camera(boss.global_position), "completed")
	var dialog = spawn_dialog("BossIntro")
	yield(dialog, "dialogic_signal")
	pan_camera(shield_tower_2.global_position)
	yield(dialog, "dialogic_signal")
	yield(pan_camera(player.global_position), "completed")
	

func pan_camera(target : Vector2, time := 1.0):
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(cam, "global_position", target, time)
	yield(tween, "finished")

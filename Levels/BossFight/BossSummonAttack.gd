extends Node2D

export(PackedScene) var enemy_scene

func spawn_enemy():
	var enemy = enemy_scene.instance()
	get_parent().add_child(enemy)
	enemy.global_position = $EnemySpawnPoint.global_position

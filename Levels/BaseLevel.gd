extends Node2D

onready var cam:Camera2D = get_node("Camera2D")
onready var player:KinematicBody2D = find_node("Player")
onready var tileMapLevel1:TileMap = get_node("TileMapLevel1")

# Called when the node enters the scene tree for the first time.
func _ready():
	StageManager.current_map = self
	#assign_player2passObjs()

func assign_player2passObjs():
	for child in tileMapLevel1.get_children():
		if child.has_method("set_player"):
			child.set_player(player)
		pass

func _draw():
	draw_circle(player.position,50,Color(1,0.2,0))

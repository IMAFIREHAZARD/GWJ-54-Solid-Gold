extends Node2D

onready var cam:Camera2D = get_node("Camera2D")
onready var player:KinematicBody2D = find_node("Player")
onready var tileMapLevel1:TileMap = find_node("TileMapLevel1")
onready var tileMapGround : TileMap = find_node("TileMapGround")
onready var tileMapGroundSidesL : TileMap = find_node("TileMapGroundSidesL")
onready var tileMapGroundSidesR : TileMap = find_node("TileMapGroundSidesR")
# Called when the node enters the scene tree for the first time.
func _ready():
	StageManager.current_map = self
	assign_player2passObjs()

func assign_player2passObjs():
	if tileMapLevel1 != null:
		for child in tileMapLevel1.get_children():
			if child.has_method("set_player"):
				child.set_player(player)
			pass

func get_tile_underneath(pos_global:Vector2):
	if tileMapGround == null:
		return
		
	var local_position = tileMapGround.to_local(pos_global)
	var map_position = tileMapGround.world_to_map(local_position)
	var tileSet = tileMapGround.tile_set
	var tileID = tileMapGround.get_cellv(map_position)
	if tileID != -1:
		var tileName = tileSet.tile_get_name(tileID)
		return tileName
	else:
		return "Void"

func _physics_process(_delta):
	## check if player is falling
	if get_tile_underneath(player.global_position)=="Void" and player.has_method("fall_off_map"):
		player.fall_off_map()

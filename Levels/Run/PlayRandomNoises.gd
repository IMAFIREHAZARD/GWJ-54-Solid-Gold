extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_random_noise():
	var noises = get_children()
	var randomNoise = noises[randi()%noises.size()]
	randomNoise.start()

func play_random_music():
	var music = get_children()
	var randomMusic = music[randi()%music.size()]
	randomMusic.play()
	

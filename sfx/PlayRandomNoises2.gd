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
	randomNoise.start() # this method will spawn a new audiostream2d node which kills itself after one play. That allows noises to last longer than their animations (reverb, etc)

func play_random_music():
	var music = get_children()
	var randomMusic = music[randi()%music.size()]
	randomMusic.play() # using the built-in play() method, so the Node won't destroy itself after one playthrough

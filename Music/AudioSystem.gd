"""
Dynamic Music pulse system to help us sync music tracks on the beat.

Nodes that care about timing can subscribe_to_pulse_beat() and wait for regular signals to hit their callback function

"""

extends Node



var time_at_last_beat : float = 0.0
var time_at_last_bar : float = 0.0

var elapsed_time_sec : float = 0.0

signal pulse_beat()


# Called when the node enters the scene tree for the first time.
func _ready():
#	Global.audio_manager = self
	pass

func subscribe_to_pulse_beat(listenerNode, callbackFunction):
	# nodes which need precise timing for audio events can subscribe to the audio_manager to receive timed signals
	var err = connect("pulse_beat", listenerNode, callbackFunction)
	if err != OK:
		printerr("problem in AudioSystem, subscribe_to_pulses_beat(). Error: ", err)


func unsubscribe(uninterestedListenerNode, callbackFunction):
	if is_connected("pulse_beat", uninterestedListenerNode, callbackFunction):
		disconnect("pulse_beat", uninterestedListenerNode, callbackFunction)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.is_paused() == true:
		return
	
	elapsed_time_sec += delta
	
	var bpm = Global.bpm
	var beat_duration = 60.0 / bpm

	if elapsed_time_sec - time_at_last_beat > beat_duration:
		emit_signal("pulse_beat")
		time_at_last_beat = elapsed_time_sec
#	else:
#		print("elapsed: ", elapsed_time_sec, ", last_beat: ", time_at_last_beat, ", duration: ", beat_duration)





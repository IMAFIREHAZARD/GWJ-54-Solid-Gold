extends TextureRect


var last_frame : int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# we have 10 health represented by 5 hearts.
	# each heart is 2 health.
	# so we divide the player's health by 2 to get the heart's position.

	# frame 1 is a full heart, 2 half heart, 3 empty heart
	var HP_per_heart : int = 2

	var full_hearts = floor(float(Global.player_health_remaining) / float(HP_per_heart))
	var half_hearts = int(Global.player_health_remaining) % HP_per_heart
	var empty_hearts = 5-full_hearts + half_hearts	
	
	var pos = get_position_in_parent() # watch for divide by one errors when using positions
	if pos < full_hearts:
		$HeartSprite.frame = 0
	elif pos < full_hearts + half_hearts:
		$HeartSprite.frame = 1
	else:
		$HeartSprite.frame = 2 
	
	if $HeartSprite.frame != last_frame:
		var tween = get_tree().create_tween()
		tween.parallel().tween_property($HeartSprite, "scale", Vector2(0.85, 0.85), 0.5).set_trans(Tween.TRANS_BOUNCE)
		tween.parallel().tween_property($HeartSprite, "position", $HeartSprite.position - Vector2(0, 3), 0.5).set_trans(Tween.TRANS_BOUNCE)

		tween.tween_interval(0.5)
		tween.parallel().tween_property($HeartSprite, "scale", Vector2(0.5, 0.5), 0.5).set_trans(Tween.TRANS_BOUNCE)
		tween.parallel().tween_property($HeartSprite, "position", $HeartSprite.position + Vector2(0, 0), 0.5).set_trans(Tween.TRANS_BOUNCE)

	last_frame = $HeartSprite.frame


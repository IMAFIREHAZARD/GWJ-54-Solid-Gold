extends Area2D
onready var ray_cast_2d: RayCast2D = $RayCast2D

export var speed = 1000
var active = true

var quiet_launch : bool = true
var shooter

signal hit(impactVector)

func _ready() -> void:
	pass # moved launch noises into the gun
#	if shooter != StageManager.player:
#		$ShootNoises.play_random_noise()


#func muffle_noises():
#	var noiseContainers = [$ShootNoises, $WoofShootNoises, $ExplosionNoises]
#	for container in noiseContainers:
#		var noises = container.get_children()
#		for noise in noises:
#			noise.volume_db -= 7.0
#

func set_shooter(myShooter):
	shooter = myShooter
	

func _physics_process(delta: float) -> void:
	global_position += transform.x * speed * delta


func _on_Bullet_body_entered(body: Node) -> void:
	if not active: return
	
	if body.has_method("kill") and body.name != "Player":
		body.kill()
	
	elif body.has_method("_on_hit") and "Boss" in body.name:
		body._on_hit(1) # gonna need a lot of hits to kill the boss
	elif body.name == "Player" and body.has_method("_on_hit"):
		body._on_hit(1) # 1 damage
	elif body.has_method("explode_into_smithereens") and body.get("fragile") == true:
		body.explode_into_smithereens()
		animate_explosion()
	active = false

func animate_explosion():
	speed = 0 # stop moving forward
	#$ExplosionHurtbox/ExplosionSound.start_persistent()
	$SnappyExplosionNoises.play_random_persistent()
	$ThuddyExplosionNoises.play_random_persistent()
	
	$AnimatedSprite.hide()
	$Explosion/AnimatedSprite.show()
	$Explosion/AnimatedSprite.play("default")
	yield($Explosion/AnimatedSprite,"animation_finished")
	queue_free()


func _on_Timer_timeout() -> void:
	queue_free()


func _on_Bullet_area_entered(area: Area2D) -> void:
	if area is Critter: 
		for possibleCritter in $ExplosionHurtbox.get_overlapping_areas():
			if possibleCritter is Critter:
				if not is_connected("hit", possibleCritter, "_on_hit"):
					#warning-ignore:RETURN_VALUE_DISCARDED
					connect("hit", possibleCritter, "_on_hit")
				var knockbackVector = transform.x + $ExplosionHurtbox.global_position.direction_to(possibleCritter.global_position)
				emit_signal("hit", knockbackVector)
		set_collision_mask_bit(1, false)
		$CollisionShape2D.set_deferred("disabled", true)
		animate_explosion()
		
	
	elif "Boss" in area.name:
		_on_Bullet_body_entered(area)
		

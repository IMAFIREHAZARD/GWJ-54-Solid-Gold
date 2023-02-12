extends KinematicBody2D
## nodes
onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

## vars
export var move_speed := 200

var vel := Vector2()

func _physics_process(delta : float):
	## calc next move
	var move = global_position.direction_to(nav_agent.get_next_location());
	# set move speed
	var target_vel = move * move_speed
	# move
	if not nav_agent.is_navigation_finished():
		move_and_slide(target_vel)
	## adjust sprite frame dependend on move angle
	var f = round(abs(Vector2.DOWN.angle_to(vel))/deg2rad(45))
	if vel.x < 1:
		animated_sprite.scale.x = 1
	if vel.x > 1:
		animated_sprite.scale.x = -1
	animated_sprite.frame = f


func go_to_location(location:Vector2):
	# set target location
	nav_agent.set_target_location(location)
	

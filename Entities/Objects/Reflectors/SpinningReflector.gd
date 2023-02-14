extends Node2D

export var spin : bool = true

export var ping_pong : bool = false



export var speed : float = 60.0
export var rotation_speed : float = 2.0

var end_points : Array = []
var current_point_index : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.25), "timeout")
	end_points.push_back( get_global_position() )
	end_points.push_back( $PingPongTarget.get_global_position() )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation += rotation_speed * delta

	if ping_pong and end_points.size() > 0:
		var myPos = get_global_position()
		var targetPos = end_points[current_point_index]
		position += myPos.direction_to(targetPos) * speed * delta
		if (targetPos - myPos).length() < 5.0:
			current_point_index = ( current_point_index + 1 ) % end_points.size()

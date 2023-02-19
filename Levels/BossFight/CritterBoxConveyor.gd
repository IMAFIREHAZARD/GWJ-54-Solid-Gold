"""
At intervals, spawn critter crates,
moven them sown the assembly line,
then destroy them when they reach the end.

"""

extends Node2D


export var speed = 100.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for crate in $CritterBoxes.get_children():
		crate.position += Vector2(2,-1) * speed * delta

func spawn_critter_box():
	var newCrate = preload("res://Entities/Objects/Destructibles/DestructibleBoxOfCritters.tscn").instance()
	$CritterBoxes.add_child(newCrate)
	newCrate.global_position = $CritterBoxSpawner.global_position
	newCrate.connect("bugs_spawned", self, "_on_bugs_spawned")

func _on_bugs_spawned(bugs):
	for bug in bugs:
		var p = bug.global_position
		$CritterBoxes.remove_child(bug)
		get_parent().add_child(bug)
		bug.global_position = p


func _on_Timer_timeout():
	spawn_critter_box()


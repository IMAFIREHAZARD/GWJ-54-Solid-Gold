extends Control

const remapping_button_scene = preload("res://addons/key_binding/key_bind_button.tscn")

export(String) var action
export(int, 1, 5) var num_input_events

onready var label = $Label
onready var buttons_container = $ButtonsContainer


func _ready():
	generate_buttons()

# Adds a number of buttons specified by num_input_events
# for adding multiple keybinds
func generate_buttons() -> void:
	for button in buttons_container.get_children():
		button.queue_free()
	
	label.text = action.capitalize()
	if not InputMap.has_action(action): return
	var input_events = InputMap.get_action_list(action)
	for i in num_input_events:
		var button = remapping_button_scene.instance()
		button.show()
		buttons_container.add_child(button)
		button.action = action
		if i < input_events.size():
			button.event = input_events[i]
		button.update_text()

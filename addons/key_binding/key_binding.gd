extends Node

const keymaps_path = "user://keymaps.dat"
const mouse_button_names = {
	1 : "Left Mouse Button",
	2 : "Right Mouse Button",
	3 : "Middle Mouse Button",
	4 : "Scroll Wheel Up",
	5 : "Scroll Wheel Down"
}

onready var default_keymaps := get_current_keymaps()


func _ready():
	# Load saved keymaps from disk
	var file := File.new()
	if file.file_exists(keymaps_path):
		# warning-ignore:return_value_discarded
		file.open(keymaps_path, File.READ)
	
	else:
		apply_keymaps(default_keymaps)


# Applies keymaps to the current input map and saves it to disk
func apply_keymaps(new_keymaps : Dictionary) -> void:
	for action in new_keymaps:
		# make sure we don't add brand new actions (perhaps from keymaps from old versions)
		if not action in default_keymaps: continue
		InputMap.action_erase_events(action)
		for event in new_keymaps[action]:
			InputMap.action_add_event(action, event)
	
	# write keymaps to disk
	var file := File.new()
# warning-ignore:return_value_discarded
	file.open(keymaps_path, File.WRITE)
	file.store_var(get_current_keymaps(), true)
	file.close()


func get_current_keymaps() -> Dictionary:
	var current_keymaps := {}
	for action in InputMap.get_actions():
		var input_events = InputMap.get_action_list(action)
		current_keymaps[action] = input_events
	return current_keymaps

# resets keybinds to project default
func reset_keymaps() -> void:
	apply_keymaps(default_keymaps)

# saves current keybinds to disk
func save_keymaps() -> void:
	apply_keymaps(get_current_keymaps())
	

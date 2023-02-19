extends Control

var action = ""
var event : InputEvent

onready var button = $Button


func _input(new_event):
	if button.pressed and (new_event is InputEventKey or new_event is InputEventMouseButton):
		button.pressed = false
		if new_event.is_action_pressed("ui_cancel"): return
		if event and InputMap.action_has_event(action, event):
			InputMap.action_erase_event(action, event)
		InputMap.action_add_event(action, new_event)
		event = new_event
		update_text()
		get_tree().set_input_as_handled()


func update_text() -> void:
	if event is InputEventMouseButton:
		button.text = KeyBinding.mouse_button_names[event.button_index]
	elif event is InputEventKey:
		button.text = event.as_text()
	else:
		button.text = "..."


func _on_DeleteButton_pressed():
	if event is InputEvent:
		InputMap.action_erase_event(action, event)
	event = null
	update_text()

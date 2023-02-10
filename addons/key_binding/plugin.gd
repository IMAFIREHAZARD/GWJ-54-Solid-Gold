tool
extends EditorPlugin

func get_plugin_name():
	return "Key Binding"


func _enter_tree():
	add_autoload_singleton("KeyBinding", "res://addons/key_binding/key_binding.gd")


func _exit_tree():
	remove_autoload_singleton("KeyBinding")

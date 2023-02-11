extends Control

func _ready() -> void:
	if not OS.is_debug_build():
		$CenterContainer/VBoxContainer/TestingMenuButton.hide()
	if OS.get_name() == "HTML5":
		$CenterContainer/VBoxContainer/QuitButton.hide()

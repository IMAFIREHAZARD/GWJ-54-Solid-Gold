extends Control

func _ready() -> void:
	if not OS.is_debug_build():
		$"%TestingMenuButton".hide()
	if OS.get_name() == "HTML5":
		$"%QuitButton".hide()

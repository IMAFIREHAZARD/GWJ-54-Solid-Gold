extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	change_text_in_footer_to_match_keybinds()
	
func change_text_in_footer_to_match_keybinds():
	$Vbox/TogglePanelButton.text = "Help [ " + InputMap.get_action_list("help")[0].as_text() + " ]"
	#var interactKey = InputMap.get_action_list("interact")[0].as_text().left(1)
	#$Vbox/PanelContents/F_Interact/F_Interact.text = "[ " + interactKey + " ] to Interact"
	margin_top = -1 * $Vbox/TogglePanelButton.get_rect().size.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _unhandled_input(_event):
	if Input.is_action_just_pressed("help"):
		$Vbox/TogglePanelButton.pressed = !$Vbox/TogglePanelButton.pressed
		

	
func _on_InventoryButton_toggled(button_pressed):
	var pixel_offset : float = -1 * get_rect().size.y
	var duration : float = 0.15 # seconds
	if button_pressed:
		pixel_offset = -1 * $Vbox/TogglePanelButton.get_rect().size.y
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)

	tween.tween_property(self, "margin_top", pixel_offset, duration)
	$PanelOpenNoise.start()


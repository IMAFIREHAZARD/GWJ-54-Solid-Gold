extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GenericButton_mouse_entered():
	_on_hover()

func _on_GenericButton_pressed():
	$ClickNoise.start()

func _on_hover():
	if has_node("HoverNoise") and disabled == false:
		get_node("HoverNoise").start()

		var outline_font = ResourceLoader.load("res://GUI/Fonts/Cinzel28_RedGlow.tres")
		#add_font_override("purple_outline", outline_font)
		set("custom_fonts/font", outline_font)
		
		#get("custom_fonts/font").font_color = Color.red

func _on_stop_hovering():
	set("custom_fonts/font", null)


func _on_GenericButton_mouse_exited():
	_on_stop_hovering()

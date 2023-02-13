extends ParallaxLayer


export(float) var CLOUD_SPEED =-25.0


func _process(delta) -> void:
	self.motion_offset.x += CLOUD_SPEED * delta


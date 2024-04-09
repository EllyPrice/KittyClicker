extends TextureButton

func _on_adopt_timer_timeout() -> void:
	if button_pressed:
		pressed.emit()

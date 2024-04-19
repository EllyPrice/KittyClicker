extends Label

func _on_volume_slider_value_changed(value: float) -> void:
	text = str(snapped(linear_to_db(value), .1)) + "dB"

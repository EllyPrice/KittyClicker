extends CheckButton

func _on_toggled(toggled_on: bool) -> void:
	Settings.are_animations_on = toggled_on

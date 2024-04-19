extends HSlider

@export var audio_bus: StringName = &"Master"

func _ready() -> void:
	var volume: float = snapped(linear_to_db(value), .1)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(audio_bus), volume)

func _on_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var volume: float = snapped(linear_to_db(value), .1)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(audio_bus), volume)

#
#func _on_value_changed(value: float) -> void:
	#print(value, linear_to_db(value))
	#var volume: float = snapped(linear_to_db(value), .1)
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index(audio_bus), volume)

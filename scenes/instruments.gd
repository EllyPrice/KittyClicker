extends Node

func _on_note_called(instrument: StringName, pitch_scale: float = 1.0) -> void:
	if instrument == "Nyaa":
		var nyaa: AudioStreamPlayer = $Nyaa
		nyaa.pitch_scale = pitch_scale
		nyaa.play()

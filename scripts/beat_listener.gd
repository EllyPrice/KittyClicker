extends Node

signal assigned_beat_played
signal beat_received_verbose(beat: int, measures: Array, bpm: float)
signal beat_received

var assigned_beat: int


func _on_beat(beat: int, measures: Array) -> void:
	if process_mode != PROCESS_MODE_DISABLED:
		beat_received.emit()
		beat_received_verbose.emit(beat, measures)

		if assigned_beat not in measures:
			assigned_beat = beat

		if assigned_beat == beat:
			assigned_beat_played.emit()

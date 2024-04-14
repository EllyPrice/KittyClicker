extends Timer

signal beat_calculated

var beat: int
var MEASURE_SIZE: int = 33
var measures: Array = range(1, MEASURE_SIZE)

func _ready() -> void:
	beat = 1

func _on_timeout() -> void:
	print(beat)
	if beat < MEASURE_SIZE-1:
		beat += 1
	else:
		beat = 1
	get_tree().call_group("cats", "_on_beat", beat, measures, wait_time)
	beat_calculated.emit()

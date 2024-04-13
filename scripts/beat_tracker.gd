extends Timer

var beat: int = 1
var MEASURE_SIZE: int = 33
var measures: Array = range(1, MEASURE_SIZE)

func _on_timeout() -> void:
	if beat < MEASURE_SIZE-1:
		beat += 1
	else:
		beat = 1
	get_tree().call_group("cats", "_on_beat", beat, measures, wait_time)
	get_tree().call_group("sequencers", "_on_beat", beat, measures, wait_time)

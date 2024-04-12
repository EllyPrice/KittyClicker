extends Timer

var beat: int = 1
var measure_size: int = 65
var measures: Array = range(1, measure_size)

func _on_timeout() -> void:
	if beat < 64:
		beat += 1
	else:
		beat = 1
	get_tree().call_group("cats", "_on_beat", beat, measures, wait_time)
	get_tree().call_group("sequencers", "_on_beat", beat, measures, wait_time)

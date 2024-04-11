extends Timer

var beat: int = 1

func _on_timeout() -> void:
	var measures: Array = range(1, 33)
	if beat < 32:
		beat += 1
	else:
		beat = 1
	if beat in [1,8,16,24,32]:
		get_tree().call_group("cats", "_on_bar", beat)
	get_tree().call_group("cats", "_on_beat", beat, measures, wait_time)
	get_tree().call_group("instruments", "_on_beat", beat, measures, wait_time)
	get_tree().call_group("notes", "_on_beat", beat)

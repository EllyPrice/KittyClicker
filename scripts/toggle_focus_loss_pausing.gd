extends CheckButton

var pause_on_window_focus_lost: bool

func _notification(what: int) -> void:
	if is_node_ready():
		if get_tree().paused:
			if what == NOTIFICATION_WM_WINDOW_FOCUS_IN:
				get_tree().paused = false
		if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT and pause_on_window_focus_lost:
				get_tree().paused = true


func _on_toggled(toggled_on: bool) -> void:
	pause_on_window_focus_lost = toggled_on

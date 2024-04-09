extends TabContainer
var base_mem_free: int

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_menu"):
		visible = !visible

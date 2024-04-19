class_name BuyTab extends VBoxContainer

@export var parent: TabContainer
var parent_tab_idx: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parents_child_count: int = parent.get_child_count()
	for parents_child: int in parents_child_count:
		if parent.get_child(parents_child) == self:
			parent_tab_idx = parents_child


func _on_tab_container_tab_changed(tab: int) -> void:
	if tab == parent_tab_idx:
		for child: BuyButton in get_children():
			child.process_mode = Node.PROCESS_MODE_INHERIT
			child.show()
		process_mode = Node.PROCESS_MODE_INHERIT
		show()
	elif tab != parent_tab_idx:
		for child: BuyButton in get_children():
			child.process_mode = Node.PROCESS_MODE_INHERIT
			child.show()
		process_mode = Node.PROCESS_MODE_DISABLED
		hide()

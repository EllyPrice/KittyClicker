extends TabContainer
var base_mem_free: int

func _ready() -> void:

## Sorting algorithm for emotes
## Uncomment if needed
	#var text_emotes = preload("res://scripts/emotes.gd")
	#var arr: Array[String] = [""]
	#for s: String in text_emotes.big_gato:
		#if text_emotes.amiguito.back() not in arr:
			#arr.push_back(s)
		#await Helpers.tree_timer(.01)
		#print(arr)
	#for n: int in 100:
		#for i: int in (arr.size() - 1):
			#if arr[i].length() > arr[i + 1].length():
				#var temp = arr[i + 1]
				#arr[i + 1] = arr[i]
				#arr[i] = temp
	#print(arr)
			#await Helpers.tree_timer(.01)

	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_menu"):
		visible = !visible


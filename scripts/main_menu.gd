extends TabContainer
var base_mem_free: int

func _ready() -> void:
	sort_emote_array()

func sort_emote_array() -> void:
## Sorting algorithm for emotes
## Uncomment if needed
	#var arr: Array[String] = [""]
	#for s: String in Emotes.meowboy: # fill this in with whatever array needs sortin
		#if Emotes.meowboy.back() not in arr:
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
	#for s: String in arr:
		#print("\"", s, "\",")
	pass

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("open_menu"):
		visible = !visible


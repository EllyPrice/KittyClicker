class_name BuyLure extends BuyButton

@export var LURE_SCENE: PackedScene
@export var cost: float = 10.0

@export var lure_normal: Texture2D
@export var lure_hover: Texture2D
@export var lure_pressed: Texture2D
@export var lure_undiscovered: Texture2D

var number_owned: int
var original_cost: float
var sold_instance_id: int

@onready var cost_label: Label = %CostLabel
@onready var buy_button: TextureButton = %BuyButton


func _ready() -> void:
	if Coins.amount < cost:
		buy_button.texture_normal = lure_undiscovered
		buy_button.texture_hover = lure_undiscovered
		buy_button.texture_pressed = lure_undiscovered

	original_cost = cost
	cost_label.text = str(cost)


func _process(_delta: float) -> void:
	if Coins.amount > cost:
		buy_button.texture_normal = lure_normal
		buy_button.texture_hover = lure_hover
		buy_button.texture_pressed = lure_pressed


func _on_buy_button_pressed() -> void:
	if Coins.amount > cost:
		var lure: Lure = LURE_SCENE.instantiate()
		lure.global_position = get_global_mouse_position()
		lure.is_in_hand = true
		lure.cost = cost

		sold_instance_id = lure.get_instance_id()

		get_tree().root.add_child(lure)


func lure_found_cat(lure_instance_id: int) -> void:
	if lure_instance_id == sold_instance_id:
		number_owned += 1
		cost = original_cost * (1.15 ** number_owned)
		cost_label.text = str(cost)


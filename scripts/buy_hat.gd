class_name BuyHat extends BuyButton

@export var HAT_SCENE: PackedScene
@export var cost: float = 10.0

@export var hat_normal: Texture2D
@export var hat_hover: Texture2D
@export var hat_pressed: Texture2D
@export var hat_undiscovered: Texture2D
@export var emote_library_name: StringName

var number_owned: int
var original_cost: float
var sold_instance_id: int

@onready var cost_label: Label = %CostLabel
@onready var buy_button: TextureButton = %BuyButton

func _ready() -> void:
	if Coins.amount < cost:
		buy_button.texture_normal = hat_undiscovered
		buy_button.texture_hover = hat_undiscovered
		buy_button.texture_pressed = hat_undiscovered

	original_cost = cost
	cost_label.text = str(cost)

func _process(_delta: float) -> void:
	if Coins.amount > cost:
		buy_button.texture_normal = hat_normal
		buy_button.texture_hover = hat_hover
		buy_button.texture_pressed = hat_pressed

func _on_buy_button_pressed() -> void:
	if Coins.amount > cost:
		var hat: Hat = HAT_SCENE.instantiate()
		hat.global_position = get_global_mouse_position()
		hat.is_in_hand = true
		hat.cost = cost

		sold_instance_id = hat.get_instance_id()

		get_tree().root.add_child(hat)

func hat_found_cat(hat_instance_id: int) -> void:
	if hat_instance_id == sold_instance_id:
		number_owned += 1
		cost = original_cost * (1.15 ** number_owned)
		cost_label.text = str(cost)


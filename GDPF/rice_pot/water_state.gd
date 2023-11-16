extends State
class_name WaterState

signal rice_dropped

@onready var pan : Pan = $"../../"
@onready var animator: AnimatedSprite2D = pan.get_node("AnimatedSprite2D")

func _ready():
	pan.ingredient_released_on_pan.disconnect(_on_pan_ingredient_released)

func _enter_state():
	print("Entered Water State")
	pan.ingredient_released_on_pan.connect(_on_pan_ingredient_released)
	animator.play(get_name())

func _exit_state():
	print("Exited Water State")
	pan.ingredient_released_on_pan.disconnect(_on_pan_ingredient_released)

func _on_pan_ingredient_released(ingredient, pan):
	if ingredient == "rice":
		rice_dropped.emit()


extends State
class_name WaterState

signal rice_dropped

@onready var _pan : Pan = $"../../"
@onready var _animator: AnimatedSprite2D = _pan.get_node("AnimatedSprite2D")

func _ready():
	_pan.ingredient_released_on_pan.disconnect(_on_pan_ingredient_released)

func _enter_state():
	print("Entered Water State")
	_pan.ingredient_released_on_pan.connect(_on_pan_ingredient_released)
	_animator.play(get_name())

func _exit_state():
	print("Exited Water State")
	_pan.ingredient_released_on_pan.disconnect(_on_pan_ingredient_released)

func _on_pan_ingredient_released(ingredient, pan):
	if ingredient == "rice":
		rice_dropped.emit()


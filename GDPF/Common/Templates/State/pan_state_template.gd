extends State
#class_name TemplateState

signal water_dropped

@onready var _pan : Pan = $"../../"
@onready var _animator: AnimatedSprite2D = _pan.get_node("AnimatedSprite2D")

func _ready():
	_pan.ingredient_released_on_pan.disconnect(_on_pan_ingredient_released)

func _enter_state() -> void:
	print("Entered Template State")
	_pan.ingredient_released_on_pan.connect(_on_pan_ingredient_released)

func _exit_state() -> void:
	print("Exited Template State")
	_pan.ingredient_released_on_pan.disconnect(_on_pan_ingredient_released)

func _on_pan_ingredient_released(ingredient, pan):
	if ingredient == "water":
		water_dropped.emit()

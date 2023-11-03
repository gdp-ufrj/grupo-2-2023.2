extends State
class_name TemplateState

signal water_dropped

@export var animator: AnimatedSprite2D

@onready var pan : Pan = $"../../"

func _ready():
	pan.ingredient_released_on_pan.disconnect(_on_pan_ingredient_released)

func _enter_state():
	print("Entered Template State")
	pan.ingredient_released_on_pan.connect(_on_pan_ingredient_released)

func _exit_state():
	print("Exited Template State")
	pan.ingredient_released_on_pan.disconnect(_on_pan_ingredient_released)

func _on_pan_ingredient_released(ingredient, pan):
	if ingredient == "water":
		water_dropped.emit()


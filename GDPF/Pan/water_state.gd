extends State
class_name WaterState

signal rice_dropped

@export var animator: AnimatedSprite2D

@onready var pan : Pan = $"../../"

func _ready():
	pan.ingredient_released_on_pan.disconnect(_on_pan_ingredient_released)

func _enter_state():
	print("Entered Water State")
	pan.ingredient_released_on_pan.connect(_on_pan_ingredient_released)

func _exit_state():
	print("Exited Water State")
	pan.ingredient_released_on_pan.disconnect(_on_pan_ingredient_released)

func _on_pan_ingredient_released(ingredient, pan):
	if ingredient == "rice":
		rice_dropped.emit()


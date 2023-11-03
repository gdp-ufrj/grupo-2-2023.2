extends State
class_name CookingState

signal water_dropped

@export var animator: AnimatedSprite2D

@onready var pan : Pan = $"../../"

func _ready():
	pan.ingredient_released_on_pan.disconnect(_on_pan_ingredient_released)

func _enter_state():
	print("Entered Cooking State")
	pan.ingredient_released_on_pan.connect(_on_pan_ingredient_released)

func _exit_state():
	print("Exited Cooking State")
	pan.ingredient_released_on_pan.disconnect(_on_pan_ingredient_released)

func _on_pan_ingredient_released(ingredient, pan):
	pass
#	if ingredient == "water":
#		water_dropped.emit()


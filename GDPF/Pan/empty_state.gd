class_name EmptyState
extends State

signal rice_dropped
signal water_dropped

@export var animator: AnimatedSprite2D

@onready var pan : Pan = $"../../"

func _ready():
	pan.ingredient_released_on_pan.disconnect(_on_pan_ingredient_released)

func _enter_state() -> void:
	print("Entered Empty State")
	pan.ingredient_released_on_pan.connect(_on_pan_ingredient_released)
	
func _exit_state() -> void:
	print("Exited Empty State")
	pan.ingredient_released_on_pan.disconnect(_on_pan_ingredient_released)

func _on_pan_ingredient_released(ingredient, pan):
	if ingredient == "rice":
		rice_dropped.emit()
	if ingredient == "water":
		water_dropped.emit()

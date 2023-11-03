class_name IngredientSpawner
extends Node2D

signal ingredient_grabbed
signal ingredient_released(ingredient)

@export var ingredient_name:String = "Egg"

var _is_grabbing_ingredient := false

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_mouse"):
			_is_grabbing_ingredient = true
			ingredient_grabbed.emit()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_released("left_mouse") and _is_grabbing_ingredient:
			ingredient_released.emit(ingredient_name)
			_is_grabbing_ingredient = false

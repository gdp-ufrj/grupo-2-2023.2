class_name Pan
extends Node2D

@export var pan_name: String
@export var recipes: Array[String]

signal ingredient_released_outside_pan(ingredient)
signal ingredient_released_on_pan(ingredient, pan)

var _is_mouse_inside = false

func _on_ingredient_released(ingredient):
	if (_is_mouse_inside):
		ingredient_released_on_pan.emit(ingredient)

func _on_area_2d_mouse_entered():
	_is_mouse_inside = true
	
func _on_area_2d_mouse_exited():
	_is_mouse_inside = false


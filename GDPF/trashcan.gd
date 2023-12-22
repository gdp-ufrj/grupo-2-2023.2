extends Node2D
class_name Trashcan


var _is_mouse_inside_trashcan = false

func _on_area_2d_mouse_entered():
	_is_mouse_inside_trashcan = true
	
func _on_area_2d_mouse_exited():
	_is_mouse_inside_trashcan = false

func _on_released_cooked_ingredient(ingredient, decrease_ingredient):
	if(_is_mouse_inside_trashcan):
		decrease_ingredient.call()


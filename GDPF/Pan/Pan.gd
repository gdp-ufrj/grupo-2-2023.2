extends Node2D

@export var pan_name: String
@export var recipes: Array[String]

signal ingredient_released_outside_pan(ingredient)
signal ingredient_released_on_pan(state, ingredient, pan)

enum States {EMPTY, WITH_WATER, COOKING, COOKED, BURNT}

var _state = States.EMPTY
var _is_mouse_inside = false

func _on_ingredient_released_on_pan(state, ingredient, pan):
	if _state == States.EMPTY:
		print(ingredient)
		_state = States.COOKING

func _on_ingredient_released(ingredient):
	if (recipes.has(ingredient) && _is_mouse_inside):
		ingredient_released_on_pan.emit(_state, ingredient, pan_name)

func _on_area_2d_mouse_entered():
	_is_mouse_inside = true
	
func _on_area_2d_mouse_exited():
	_is_mouse_inside = false

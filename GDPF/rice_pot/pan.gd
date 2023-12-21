class_name Pan
extends Node2D

@export var pan_name: String
@onready var area2d: Area2D = $Area2D

signal ingredient_released_outside_pan(ingredient)
signal ingredient_released_on_pan(ingredient)

var _is_mouse_inside = false

func _on_ingredient_released(ingredient):
	if (_is_mouse_inside):
		ingredient_released_on_pan.emit(ingredient)

func _on_area_2d_mouse_entered():
	_is_mouse_inside = true
	
func _on_area_2d_mouse_exited():
	_is_mouse_inside = false

func _on_water_container_ingredient_released(ingredient, drop_area):
	var overlapping_areas = area2d.get_overlapping_areas()

	if overlapping_areas.size() > 0:
		for area in overlapping_areas:
			if(area == drop_area):
				ingredient_released_on_pan.emit(ingredient)

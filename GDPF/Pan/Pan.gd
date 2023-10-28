extends Node2D
var ingredient_inside: Node2D
enum states {EMPTY, WITH_WATER, COOKING, COOKED, BURNT}
@export var recipes: Array[String]
var state = states.EMPTY
# Called every frame. 'delta' is the elapsed time since the previous frame.
	
func _on_area_2d_area_entered(area):
	if recipes.has(area.get_parent().get_parent().ingredient_name):
		ingredient_inside = area.get_parent().get_parent()

func _on_area_2d_area_exited(area):
	if recipes.has(area.get_parent().get_parent().ingredient_name):
		ingredient_inside = null
	#necessario para que os cliques sem itens arrastados não coloquem mais coisas na panela 

func _on_area_2d_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.is_action_released("left_mouse")):
		if (ingredient_inside != null):
			if (recipes.has(ingredient_inside.ingredient_name) && state == states.EMPTY):
				state = states.COOKING
	pass # Replace with function body.


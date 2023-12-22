extends Node2D
class_name LunchBowl

@onready var _sprites := $Sprites

const possible_ingredients = [
	"cooked_rice",
	"cooked_beans",
	"cooked_chicken",
	"cooked_egg",
	"cooked_pasta",
	"salad"
]

var _is_mouse_inside_lunch_bowl = false
var current_ingredients = []
		
func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_mouse") and _is_mouse_inside_lunch_bowl:
			print("Grab Lunch Bowl")

func _on_area_2d_mouse_entered():
	_is_mouse_inside_lunch_bowl = true
	
func _on_area_2d_mouse_exited():
	_is_mouse_inside_lunch_bowl = false


func _on_released_cooked_ingredient(ingredient, decrease_ingredient = func():pass,):
	if (_is_mouse_inside_lunch_bowl and possible_ingredients.has(ingredient)):
		if(!current_ingredients.has(ingredient)):
			decrease_ingredient.call()
			current_ingredients.append(ingredient)
			_sprites.get_node(ingredient).visible = true

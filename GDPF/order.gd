extends Control
class_name Order

signal correct_order_delivered(current_mood)
signal wrong_order_delivered

@export var acceptable_ingredients = [
	"cooked_egg",
	"cooked_chicken"
]
@export var current_mood = Mood.happy

enum Mood{
	happy,
	satisfied,
	normal,
	angry
}

@onready var _ingredients = $MessageBalloon/Ingredients

var _is_mouse_inside = false

func _ready():
	_shuffle_ingredients_positions()
	_show_only_acceptable_ingredients()

func _on_lunchbowl_dropped(lunch_ingredients: Array[String]):
	lunch_ingredients.sort()
	acceptable_ingredients.sort()
	if(lunch_ingredients == acceptable_ingredients):
		correct_order_delivered.emit(current_mood)
	else:
		wrong_order_delivered.emit()
	
func _on_correct_order_delivered(current_mood: Mood):
	self.queue_free()

func _shuffle_ingredients_positions():
	var ingredients_positions = []
	var ingredients_children = _ingredients.get_children()
	for ingredient in ingredients_children:
		ingredients_positions.append(ingredient.get_position())
	ingredients_positions.shuffle()
	for i in ingredients_children.size():
		ingredients_children[i].set_position(ingredients_positions[i])
		
func _show_only_acceptable_ingredients():
	var ingredients_children = _ingredients.get_children()
	for ingredient in ingredients_children:
		if acceptable_ingredients.has(ingredient.name):
			ingredient.visible = true
		else:
			ingredient.visible = false
			

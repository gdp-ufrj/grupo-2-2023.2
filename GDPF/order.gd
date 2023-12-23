extends TextureRect
class_name Order

signal correct_order_delivered(current_mood: Mood)
signal wrong_order_delivered

var possible_ingredients = [
	"cooked_rice",
	"cooked_beans",
	"cooked_chicken",
	"cooked_egg",
	"cooked_pasta",
	"salad"
]

var acceptable_ingredients = []

@export var current_mood = Mood.happy
@export var min_ingredient_amount = 2
@export var max_ingredient_amount = 6

enum Mood{
	happy,
	satisfied,
	normal,
	angry
}

@onready var _ingredients = $Ingredients
@onready var _animator = $OrderBalloon

var _is_lunch_inside = false

func _animator_play_mood(mood : Mood):
	_animator.play(Mood.keys()[mood])

func _ready():
	_shuffle_ingredients_positions()
	_randomize_acceptable_ingredients(min_ingredient_amount, max_ingredient_amount)
	_show_only_acceptable_ingredients()
	_animator_play_mood(current_mood)

func _randomize_acceptable_ingredients(min_amount, max_amount):
	possible_ingredients.shuffle()
	self.acceptable_ingredients = possible_ingredients.slice(0, randi_range(max(1, min_amount), min(max_amount, possible_ingredients.size()-1)))

func on_lunch_bowl_lunch_dropped(lunch_ingredients: Array[String], drop_inside_callback = func(): pass):
	print("on_lunch_bowl_dropped")
	print(drop_inside_callback)
	drop_inside_callback.call()
	lunch_ingredients.sort()
	acceptable_ingredients.sort()
	print(lunch_ingredients, acceptable_ingredients)
	if(lunch_ingredients.hash() == acceptable_ingredients.hash() and _is_lunch_inside):
		correct_order_delivered.emit(current_mood)
		_on_correct_order_delivered(current_mood)
	else:
		wrong_order_delivered.emit()

	
func _on_correct_order_delivered(current_mood: Mood):
	print("Delivered order with " + Mood.keys()[current_mood])
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
		


func _on_area_2d_area_entered(area):
	for child in self.get_children():
		if child is LunchBowl:
			_is_lunch_inside = true
			_animator.scale = Vector2(1.1, 1.1)
	
func _on_area_2d_area_exited(area):
	for child in self.get_children():
		if child is LunchBowl:
			_is_lunch_inside = true
			_animator.scale = Vector2.ONE

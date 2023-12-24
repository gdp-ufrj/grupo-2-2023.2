extends TextureRect
class_name Order

signal correct_order_delivered(current_mood: Mood)
signal wrong_order_delivered

var possible_ingredients : Array[String] = [
	"cooked_rice",
	"cooked_beans",
	"cooked_chicken",
	"cooked_egg",
	"cooked_pasta",
	"salad"
]

const ingredients_price = {
	"cooked_rice": 3,
	"cooked_beans": 4,
	"cooked_chicken": 8,
	"cooked_egg": 2,
	"cooked_pasta": 5,
	"salad": 4
}

const mood_price_multiplier = {
	"happy": 2,
	"satisfied": 1.5,
	"normal": 1,
	"angry": 0.5
}

const ingredient_wait_time = {
	"cooked_rice": 48,
	"cooked_beans": 80,
	"cooked_chicken": 64,
	"cooked_egg": 32,
	"cooked_pasta": 40,
	"salad": 15
}

var acceptable_ingredients : Array[String] = []

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
@onready var _animator : AnimatedSprite2D = $OrderBalloon
@onready var _timer : TimerWithRect = $Timer
@onready var _score_controller : ScoreController = get_tree().get_root().get_node("Kitchen").get_node("%ScoreController")

var _is_lunch_inside = false

func _animator_play_mood(mood : Mood):
	_animator.play(Mood.keys()[mood])
	
func _process(dt):
	var percent_time_left = _timer.time_left / _timer.wait_time
	if(percent_time_left > 0.75):
		current_mood = Mood.happy
	elif(percent_time_left > 0.5):
		current_mood = Mood.satisfied
	elif(percent_time_left > 0.25):
		current_mood = Mood.normal
	else:
		current_mood = Mood.angry
	_animator_play_mood(current_mood)
	
func _ready():
	_shuffle_ingredients_positions()
	_randomize_acceptable_ingredients(min_ingredient_amount, max_ingredient_amount)
	_show_only_acceptable_ingredients()
	_animator_play_mood(current_mood)
	_set_up_timer(acceptable_ingredients)

func _set_up_timer(acceptable_ingredients):
	var time_sum = 0
	for ingredient in acceptable_ingredients:
		time_sum += ingredient_wait_time[ingredient]
	_timer.set_wait_time(time_sum)
	_timer.start()
	
func _randomize_acceptable_ingredients(min_amount, max_amount):
	possible_ingredients.shuffle()
	self.acceptable_ingredients = possible_ingredients.slice(0, randi_range(max(1, min_amount), min(max_amount, possible_ingredients.size()-1)))

func on_lunch_bowl_lunch_dropped(lunch_ingredients: Array[String], drop_inside_callback = func(): pass):
	lunch_ingredients.sort()
	acceptable_ingredients.sort()
	drop_inside_callback.call()
	if(lunch_ingredients.hash() == acceptable_ingredients.hash() and _is_lunch_inside):
		correct_order_delivered.emit(current_mood)
		_on_correct_order_delivered(current_mood)
	else:
		wrong_order_delivered.emit()

	
func _on_correct_order_delivered(current_mood: Mood):
	print("Delivered order with " + Mood.keys()[current_mood])
	var _deliever_score = _calculate_score(current_mood, acceptable_ingredients)
	_score_controller.increase_score_by(_deliever_score)
	get_node("OrderBalloon/numbers_popup").popup(_deliever_score)
	self.queue_free()
	
func _on_wrong_order_delivered(current_mood: Mood):
	print("Wrong Delivery")
	self.queue_free()
	
	
func _calculate_score(mood: Mood, ingredients: Array[String]):
	var sum : float = 0
	for ingredient in acceptable_ingredients:
		sum += ingredients_price[ingredient]
	sum *= mood_price_multiplier[Mood.keys()[mood]]
	return sum

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

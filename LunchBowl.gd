extends Node2D
class_name LunchBowl

signal lunch_dropped(ingredients: Array[String], drop_inside_callback)

@onready var _sprites := $Sprites
@onready var _initial_position = self.global_position
@onready var _initial_parent = self.get_parent()

const possible_ingredients = [
	"cooked_rice",
	"cooked_beans",
	"cooked_chicken",
	"cooked_egg",
	"cooked_pasta",
	"salad"
]

var _is_mouse_inside_lunch_bowl = false
var current_ingredients : Array[String] = []
var _is_being_grabbed = false

func _drop_inside_callback():
	self.reparent(_initial_parent)
	for ingredient in self.current_ingredients:
		_sprites.get_node(ingredient).visible = false
	self.current_ingredients = []

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_mouse") and _is_mouse_inside_lunch_bowl:
			_is_being_grabbed = true
		if event.is_action_released("left_mouse") and _is_mouse_inside_lunch_bowl:
			_is_being_grabbed = false
			lunch_dropped.emit(current_ingredients, _drop_inside_callback)
			self.global_position = _initial_position
	if event is InputEventMouseMotion and _is_being_grabbed:
		self.global_position = event.position

func _on_area_2d_mouse_entered():
	_is_mouse_inside_lunch_bowl = true
	
func _on_area_2d_mouse_exited():
	_is_mouse_inside_lunch_bowl = false
	
func _on_released_cooked_ingredient(ingredient, released_inside_callback = func():pass, released_outside_callback = func():pass):
	if (_is_mouse_inside_lunch_bowl and possible_ingredients.has(ingredient)):
		if(!current_ingredients.has(ingredient)):
			released_inside_callback.call()
			current_ingredients.append(ingredient)
			_sprites.get_node(ingredient).visible = true
	else:
		released_outside_callback.call()


func _on_area_2d_area_entered(area : Area2D):
	if(area.get_parent() is Order):
		var target_order := area.get_parent() as Order
		self.reparent(target_order)
		lunch_dropped.connect(target_order.on_lunch_bowl_lunch_dropped)


func _on_area_2d_area_exited(area : Area2D):
		if(area.get_parent() is Order):
			var target_order := area.get_parent() as Order
			lunch_dropped.disconnect(target_order.on_lunch_bowl_lunch_dropped)
			if(self.get_parent() == target_order):
				self.reparent(_initial_parent)

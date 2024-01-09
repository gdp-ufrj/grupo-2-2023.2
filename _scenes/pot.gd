@tool
extends Node2D
class_name Pot

signal ingredient_released_on_area(ingredient)

@export_enum("brown", "red", "gray") var pot_color : String = "brown":
	set(new_value):
		pot_color = new_value
		_set_pot_sprites(pot_color, current_ingredient, current_state)
		
@export_enum("empty", "rice", "beans", "pasta") var current_ingredient : String = "empty":
	set(new_value):
		current_ingredient = new_value
		_set_pot_sprites(pot_color, current_ingredient, current_state)
		
@export_enum("raw", "water", "cooking", "cooked", "overcooked") var current_state : String = "raw":
	set(new_value):
		current_state = new_value
		_set_pot_sprites(pot_color, current_ingredient, current_state)

@export_category("Beans")
@export var beans_servings_amount : int = 4
@export var beans_cooking_time : float = 14
@export var beans_burned_time : float = 6
@export_category("Rice")
@export var rice_servings_amount : int = 3
@export var rice_cooking_time : float = 8
@export var rice_burned_time : float = 6
@export_category("Pasta")
@export var pasta_servings_amount : int = 3
@export var pasta_cooking_time : float = 7
@export var pasta_burned_time : float = 11
@export_category("Audios")
@export var _on_cooking_start_audio : AudioStream
@export var _on_cooking_audio_loop : AudioStream
@export var _on_overcooked_audio : AudioStream

@onready var area2d: Area2D = $Area2D
@onready var _audio := $AudioStreamPlayer2D
@onready var _animator: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var _fire_controller: FireController = get_node("FireController")
@onready var _timer : Timer = get_node("Timer")

@onready var _front_sprite : AnimatedSprite2D = $Sprites/Front
@onready var _ingredient_sprite : AnimatedSprite2D = $Sprites/Ingredient
@onready var _back_sprite : AnimatedSprite2D = $Sprites/Back

var ingredients = {
	"rice": {
		"servings_amount": rice_servings_amount,
		"cooking_time": rice_cooking_time,
		"burned_time": rice_burned_time
	},
	"beans": {
		"servings_amount": beans_servings_amount,
		"cooking_time": beans_cooking_time,
		"burned_time": beans_burned_time
	},
	"pasta": {
		"servings_amount": pasta_servings_amount,
		"cooking_time": pasta_cooking_time,
		"burned_time": pasta_burned_time
	},
}

var _current_state_name = "EmptyState"
var _is_mouse_inside = false
var _is_grabbing_ingredient = false
var _ingredient_count = 0

var States = {
	"empty": {
		"on_state_enter":
			func():
				_audio.stop(),
		"on_ingredient_added": 
			func(ingredient): 
				if(ingredient == "beans"): 
					_switch_to_state("BeansState")
				if(ingredient == "water"):
					_switch_to_state("WaterState"),
	},
	"ingredient": {
		"on_ingredient_added":
			func(ingredient_name):
				if(ingredient_name == "water"):
					_switch_to_state("BeansAndWaterState"),
	},
	"water": {
		"on_fire_start":
			func():
				_audio.stream = _on_cooking_audio_loop
				_audio.play(),
		"on_fire_stop":
			func():
				_audio.stop(),
		"on_ingredient_added":
			func(ingredient_name):
				if(ingredient_name == "beans"):
					_switch_to_state("BeansAndWaterState"),
	},
	"water_ingredient": {
		"on_fire_start":
			func():
				_switch_to_state("CookingState")
				_audio.stream = _on_cooking_audio_loop
				_audio.play(),
		"on_fire_stop":
			func():
				_audio.stop(),
		"on_state_enter":
			func():
				if(_fire_controller.state_is_on):
					_audio.stream = _on_cooking_audio_loop
					_audio.play()
					_switch_to_state("CookingState"),
	},
	"cooking": {
		"timer_wait": 14,
		"on_fire_start":
			func():
				_audio.stream = _on_cooking_audio_loop
				_audio.play(),
		"on_fire_stop":
			func():
				_audio.stop()
				_switch_to_state("BeansAndWaterState"),
		"on_timer_timeout":
			func():
				_switch_to_state("CookedState"),
	},
	"cooked": {
		"timer_wait": 6,
		"on_state_enter":
			func():
				_ingredient_count = ingredients[current_ingredient]["servings_amount"],
		"on_timer_timeout":
			func():
				_switch_to_state("OvercookedState"),
		"on_fire_stop":
			func():
				_audio.stop()
				_timer.stop(),
		"on_fire_start":
			func():
				_audio.stream = _on_cooking_audio_loop
				_audio.play()
				_timer.start(),
	},
	"overcooked": {
		"timer_wait": 5,
		"on_state_enter":
			func():
				_audio.stream = _on_overcooked_audio
				_audio.play(),
		"on_timer_timeout":
			func():
				_switch_to_state("EmptyState")
				_fire_controller.fire_turned_off.emit(),
	},
}

func _set_pot_sprites(pot_color, current_ingredient, current_state):
	var front_sprite : AnimatedSprite2D = _front_sprite if _front_sprite else $Sprites/Front
	var ingredient_sprite : AnimatedSprite2D = _ingredient_sprite if _ingredient_sprite else $Sprites/Ingredient
	var back_sprite : AnimatedSprite2D  = _back_sprite if _back_sprite else $Sprites/Back
	
	if (current_ingredient == "rice" or current_ingredient == "beans") and current_state == "cooking":
		front_sprite.visible = false
		ingredient_sprite.visible = false
		back_sprite.play("pot_closed_%s" % pot_color)
	else:
		front_sprite.visible = true
		ingredient_sprite.visible = true
		back_sprite.play("pot_back_%s" % pot_color)
		front_sprite.play("pot_front_%s" % pot_color)
	
	if current_ingredient == "empty" and current_state != "water":
		ingredient_sprite.play("empty")
	else:
		ingredient_sprite.play("%s_%s" % [current_state, current_ingredient])

func _on_ingredient_released(ingredient, released_inside_callback, released_outside_callback):
	if (_is_mouse_inside):
		ingredient_released_on_area.emit(ingredient)
		released_inside_callback.call()
	else:
		released_outside_callback.call()

func decrease_ingredient():
	_ingredient_count -= 1
		
func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_mouse") and _is_mouse_inside and _current_state_name == "CookedState":
#			grabbed_cooked_ingredient.emit(current_ingredient)
			_is_grabbing_ingredient = true
		if event.is_action_released("left_mouse") and _is_grabbing_ingredient:
#			released_cooked_ingredient.emit(current_ingredient, decrease_ingredient)
			_is_grabbing_ingredient = false
			if(_ingredient_count == 0):
				_switch_to_state("EmptyState")

func _on_area_2d_mouse_entered():
	_is_mouse_inside = true
	
func _on_area_2d_mouse_exited():
	_is_mouse_inside = false

func _on_water_container_ingredient_released(ingredient, drop_area):
	var overlapping_areas = area2d.get_overlapping_areas()

	if overlapping_areas.size() > 0:
		for area in overlapping_areas:
			if(area == drop_area):
				ingredient_released_on_area.emit(ingredient)


func _ready():
	_switch_to_state(_current_state_name)

func _switch_to_state(next_state_name):
	print("from " + _current_state_name + " to " + next_state_name)
	var current_state = States.get(_current_state_name)
	var next_state = States.get(next_state_name)
	_animator.play(next_state_name)
	
	if(current_state.get("on_ingredient_added") and ingredient_released_on_area.is_connected(current_state.get("on_ingredient_added"))):
		ingredient_released_on_area.disconnect(current_state.get("on_ingredient_added"))
	if(next_state.get("on_ingredient_added")):
		ingredient_released_on_area.connect(next_state.get("on_ingredient_added"))
		
	if(current_state.get("on_timer_timeout")):
		_timer.stop()
		_timer.timeout.disconnect(current_state.get("on_timer_timeout"))
	if(next_state.get("on_timer_timeout")):
		_timer.wait_time = next_state.get("timer_wait")
		_timer.start()
		_timer.timeout.connect(next_state.get("on_timer_timeout"))
		
	if(current_state.get("on_fire_start")):
		_fire_controller.fire_turned_on.disconnect(current_state.get("on_fire_start"))
	if(next_state.get("on_fire_start")):
		_fire_controller.fire_turned_on.connect(next_state.get("on_fire_start"))
		
	if(current_state.get("on_fire_stop")):
		_fire_controller.fire_turned_off.disconnect(current_state.get("on_fire_stop"))
	if(next_state.get("on_fire_stop")):
		_fire_controller.fire_turned_off.connect(next_state.get("on_fire_stop"))
	
	_current_state_name = next_state_name
	if(current_state.get("on_state_exit")):
		current_state.get("on_state_exit").call()
	if(next_state.get("on_state_enter")):
		next_state.get("on_state_enter").call()

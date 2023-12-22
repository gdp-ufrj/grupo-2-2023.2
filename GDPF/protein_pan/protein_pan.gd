class_name ProteinPan
extends Node2D

signal ingredient_released_outside_pan(ingredient)
signal ingredient_released_on_pan(ingredient)
signal grabbed_cooked_ingredient(ingredient)
signal released_cooked_ingredient(ingredient, decrease_ingredient)

@export var pan_name: String = "protein_pan"
@export var serving_amount: int = 1

@onready var area2d: Area2D = $Area2D
@onready var _pan : ProteinPan = self
@onready var _animator: AnimatedSprite2D = _pan.get_node("AnimatedSprite2D")
@onready var _fire_controller: FireController = _pan.get_node("FireController")
@onready var _timer : Timer = _pan.get_node("Timer")

var _current_state_name = "EmptyState"
var _is_mouse_inside_pan = false
var _is_grabbing_ingredient = false
var _currently_grabbed_ingredient = null
var _ingredient_count = 0

func _on_ingredient_released(ingredient):
	if (_is_mouse_inside_pan):
		ingredient_released_on_pan.emit(ingredient)

func decrease_ingredient():
	_ingredient_count -= 1
		
func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_mouse") and _is_mouse_inside_pan:
			if _current_state_name == "CookedChickenState":
				_currently_grabbed_ingredient = "cooked_chicken"
				grabbed_cooked_ingredient.emit(_currently_grabbed_ingredient)
			if _current_state_name == "CookedEggState":
				_currently_grabbed_ingredient = "cooked_egg"
				grabbed_cooked_ingredient.emit(_currently_grabbed_ingredient)
			_is_grabbing_ingredient = true
		if event.is_action_released("left_mouse") and _is_grabbing_ingredient:
			released_cooked_ingredient.emit(_currently_grabbed_ingredient, decrease_ingredient)
			_is_grabbing_ingredient = false
			if(_ingredient_count == 0):
				_switch_to_state("EmptyState")

func _on_area_2d_mouse_entered():
	_is_mouse_inside_pan = true
	
func _on_area_2d_mouse_exited():
	_is_mouse_inside_pan = false

func _on_water_container_ingredient_released(ingredient, drop_area):
	var overlapping_areas = area2d.get_overlapping_areas()

	if overlapping_areas.size() > 0:
		for area in overlapping_areas:
			if(area == drop_area):
				ingredient_released_on_pan.emit(ingredient)
				
var States = {
	"EmptyState": {
		"on_ingredient_added": 
			func(ingredient): 
				if(ingredient == "egg"): 
					_switch_to_state("EggState")
				if(ingredient == "chicken"):
					_switch_to_state("ChickenState"),
	},
	"EggState": {
		"on_state_enter":
			func():
				if(_fire_controller.state_is_on):
					_switch_to_state("CookingEggState"),
		"on_fire_start":
			func():
				_switch_to_state("CookingEggState"),
	},
	"ChickenState": {
		"on_state_enter":
			func():
				if(_fire_controller.state_is_on):
					_switch_to_state("CookingChickenState"),
		"on_fire_start":
			func():
				_switch_to_state("CookingChickenState"),
	},
	"CookingEggState": {
		"timer_wait": 3,
		"on_fire_stop":
			func():
				_switch_to_state("EggState"),
		"on_timer_timeout":
			func():
				_switch_to_state("CookedEggState"),
	},
	"CookingChickenState": {
		"timer_wait": 5,
		"on_fire_stop":
			func():
				_switch_to_state("ChickenState"),
		"on_timer_timeout":
			func():
				_switch_to_state("CookedChickenState"),
	},
	"CookedEggState": {
		"timer_wait": 5,
		"on_state_enter":
			func():
				_ingredient_count = serving_amount,
		"on_timer_timeout":
			func():
				_switch_to_state("OvercookedEggState"),
		"on_fire_stop":
			func():
				_timer.stop(),
		"on_fire_start":
			func():
				_timer.start(),
	},
	"CookedChickenState": {
		"timer_wait": 4,
		"on_state_enter":
			func():
				_ingredient_count = serving_amount,
		"on_timer_timeout":
			func():
				_switch_to_state("OvercookedChickenState"),
		"on_fire_stop":
			func():
				_timer.stop(),
		"on_fire_start":
			func():
				_timer.start(),
	},
	"OvercookedEggState": {
		"timer_wait": 5,
		"on_timer_timeout":
			func():
				_switch_to_state("EmptyState")
				_fire_controller.fire_turned_off.emit(),
	},
	"OvercookedChickenState": {
		"timer_wait": 5,
		"on_timer_timeout":
			func():
				_switch_to_state("EmptyState")
				_fire_controller.fire_turned_off.emit(),
	},
}

func _ready():
	_switch_to_state(_current_state_name)

func _switch_to_state(next_state_name):
	print("from " + _current_state_name + " to " + next_state_name)
	var current_state = States.get(_current_state_name)
	var next_state = States.get(next_state_name)
	_animator.play(next_state_name)
	
	if(current_state.get("on_ingredient_added") and _pan.ingredient_released_on_pan.is_connected(current_state.get("on_ingredient_added"))):
		_pan.ingredient_released_on_pan.disconnect(current_state.get("on_ingredient_added"))
	if(next_state.get("on_ingredient_added")):
		_pan.ingredient_released_on_pan.connect(next_state.get("on_ingredient_added"))
		
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
	if(next_state.get("on_state_enter")):
		next_state.get("on_state_enter").call()

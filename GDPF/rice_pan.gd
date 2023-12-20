extends Node2D
class_name StateMachine

var _current_state_name = "EmptyState"

@onready var _pan : Pan = $"../"
@onready var _animator: AnimatedSprite2D = _pan.get_node("AnimatedSprite2D")
@onready var _fire_controller: FireController = _pan.get_node("FireController")
@onready var _timer : Timer = _pan.get_node("Timer")

var States = {
	"EmptyState": {
		"on_ingredient_added": 
			func(ingredient): 
				if(ingredient == "rice"): 
					_switch_to_state("RiceState")
				if(ingredient == "water"):
					_switch_to_state("WaterState"),
	},
	"RiceState": {
		"on_ingredient_added":
			func(ingredient_name):
				if(ingredient_name == "water"):
					_switch_to_state("RiceAndWaterState"),
	},
	"WaterState": {
		"on_ingredient_added":
			func(ingredient_name):
				if(ingredient_name == "rice"):
					_switch_to_state("RiceAndWaterState"),
	},
	"RiceAndWaterState": {
		"on_fire_start":
			func():
				_switch_to_state("CookingState"),
	},
	"CookingState": {
		"timer_wait": 5,
		"on_fire_stop":
			func():
				_switch_to_state("RiceAndWaterState"),
		"on_timer_timeout":
			func():
				_switch_to_state("CookedState"),
	},
	"CookedState": {
		"timer_wait": 5,
		"on_timer_timeout":
			func():
				_switch_to_state("OvercookedState"),
				
	},
	"OvercookedState": {
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
	var current_state = States.get(_current_state_name)
	var next_state = States.get(next_state_name)
	_animator.play(next_state_name)
	
	if(current_state.get("on_ingredient_added")):
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


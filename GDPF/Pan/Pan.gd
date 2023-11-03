class_name Pan
extends Node2D

@export var pan_name: String
@export var recipes: Array[String]

signal ingredient_released_outside_pan(ingredient)
signal ingredient_released_on_pan(ingredient, pan)

var _is_mouse_inside = false


@onready var fsm = $FiniteStateMachine as FiniteStateMachine
@onready var empty_state = $FiniteStateMachine/EmptyState as EmptyState
@onready var rice_state = $FiniteStateMachine/RiceState as RiceState
@onready var water_state = $FiniteStateMachine/WaterState as WaterState
@onready var cooking_state = $FiniteStateMachine/CookingState as CookingState

func _create_transition(state_signal: Signal, next_state: State):
	state_signal.connect(fsm.change_state.bind(next_state))

func _ready():
	_create_transition(empty_state.rice_dropped, rice_state)
	_create_transition(empty_state.water_dropped, water_state)
	_create_transition(rice_state.water_dropped, cooking_state)
	_create_transition(water_state.rice_dropped, cooking_state)
#	empty_state.rice_dropped.connect(fsm.change_state.bind(rice_state))
#	empty_state.water_dropped.connect(fsm.change_state.bind(water_state))
#	rice_state.water_dropped.connect(fsm.change_state.bind(cooking_state))
#	water_state.rice_dropped.connect(fsm.change_state.binf(cooking_state))

func _on_ingredient_released(ingredient):
	if (recipes.has(ingredient) && _is_mouse_inside):
		ingredient_released_on_pan.emit(ingredient, pan_name)

func _on_area_2d_mouse_entered():
	_is_mouse_inside = true
	
func _on_area_2d_mouse_exited():
	_is_mouse_inside = false

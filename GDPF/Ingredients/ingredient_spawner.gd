
extends Node2D

signal ingredient_grabbed
signal ingredient_released(ingredient, released_inside_callback, released_outside_callback)

@export var ingredient_name:String = "rice"
@export var released_inside_audio: AudioStream
@export var released_outside_audio: AudioStream

@onready var _audio = $AudioStreamPlayer2D

var _is_grabbing_ingredient := false

func released_inside_callback():
	_audio.stream = released_inside_audio
	_audio.play()

func released_outside_callback():
	_audio.stream = released_outside_audio
	_audio.play()

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_mouse"):
			_is_grabbing_ingredient = true
			ingredient_grabbed.emit()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_released("left_mouse") and _is_grabbing_ingredient:
			ingredient_released.emit(ingredient_name, released_inside_callback, released_outside_callback)
			_is_grabbing_ingredient = false

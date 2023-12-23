extends Node2D
class_name Trashcan

@export var _on_hover_audio : AudioStream
@export var _on_drop_inside_audio : AudioStream

@onready var _audio := $AudioStreamPlayer2D

var _is_mouse_inside_trashcan = false

func _on_area_2d_mouse_entered():
	_is_mouse_inside_trashcan = true
	_audio.pitch_scale = 3
	_audio.stream = _on_hover_audio
	_audio.play()
	self.scale = Vector2(1.1, 1.1)
	
func _on_area_2d_mouse_exited():
	_is_mouse_inside_trashcan = false
	self.scale = Vector2.ONE

func _on_released_cooked_ingredient(ingredient, decrease_ingredient):
	if(_is_mouse_inside_trashcan):
		decrease_ingredient.call()
		_audio.stream = _on_drop_inside_audio
		_audio.pitch_scale = 1
		_audio.play()


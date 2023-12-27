extends Node2D
class_name WaterContainer

signal ingredient_grabbed
signal ingredient_released(ingredient, drop_area)

@export var ingredient_name:String = "water"
@onready var _animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var _drop_area: Area2D = $DropArea
@onready var _audio = $AudioStreamPlayer2D
@onready var _initial_position = self.global_position


enum STATES {
	Idle,
	Grabbing,
	Dropping
}

var _current_state := STATES.Idle
var _click_offset := Vector2.ZERO

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and _current_state == STATES.Idle:
		if event.is_action_pressed("left_mouse"):
			_current_state = STATES.Grabbing
			ingredient_grabbed.emit()
			_click_offset = self.global_position - self.get_global_mouse_position()
	
func _on_water_released_animation_finished():
	ingredient_released.emit(ingredient_name, _drop_area)
	self.global_position = _initial_position
	_animator.animation_finished.disconnect(_on_water_released_animation_finished)
	_animator.play("idle")
	_current_state = STATES.Idle
	
func _input(event):
	if event is InputEventMouseMotion and _current_state == STATES.Grabbing:
		self.global_position = event.position + _click_offset
	if event is InputEventMouseButton:
		if event.is_action_released("left_mouse") and _current_state == STATES.Grabbing:
			_current_state = STATES.Dropping
			self._animator.play("released")
			self._animator.animation_finished.connect(_on_water_released_animation_finished)
			_audio.play()
			ingredient_released.emit(ingredient_name, _drop_area)
			

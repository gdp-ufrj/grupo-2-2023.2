extends Node2D
class_name FireController

signal fire_turned_on
signal fire_turned_off

@export var fire_turned_on_audio : AudioStream
@export var fire_turned_off_audio : AudioStream
@export var _on_cooking_pot_audio_loop : AudioStream
@export var _on_cooking_pan_audio_loop : AudioStream

var state_is_on:bool = false

@onready var knobSprite = $KnobSprite
@onready var fireSprite = $FireSprite

@onready var _audio := $AudioStreamPlayer2D
@onready var _pan := $"../"
@onready var _pan_audio := $"../AudioStreamPlayer2D"

func _on_fire_turned_on():
	state_is_on = true
	knobSprite.play("on")
	fireSprite.play("fire_loop")
	_audio.stream = fire_turned_on_audio
	_audio.play()


func _on_fire_turned_off():
	state_is_on = false
	knobSprite.play("off")
	fireSprite.play("fire_off")
	_audio.stream = fire_turned_off_audio
	_audio.play()
	_pan_audio.stop()


func _ready():
	fire_turned_on.connect(_on_fire_turned_on)
	fire_turned_off.connect(_on_fire_turned_off)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_mouse"):
			state_is_on = !state_is_on
			if (state_is_on):
				fire_turned_on.emit()
			else:
				fire_turned_off.emit()

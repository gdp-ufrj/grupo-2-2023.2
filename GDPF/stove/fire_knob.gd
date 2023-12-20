extends Node2D
class_name FireController

signal fire_turned_on
signal fire_turned_off

var state_is_on:bool = false

@onready var knobSprite = $KnobSprite
	

func _on_fire_turned_on():
	state_is_on = true
	knobSprite.play("on")


func _on_fire_turned_off():
	state_is_on = false
	knobSprite.play("off")


func _ready():
	fire_turned_on.connect(_on_fire_turned_on)
	fire_turned_off.connect(_on_fire_turned_off)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_mouse"):
			state_is_on = !state_is_on
			print(state_is_on)
			if (state_is_on):
				fire_turned_on.emit()
			else:
				fire_turned_off.emit()

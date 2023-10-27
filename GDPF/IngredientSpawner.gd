extends Node
@onready var ingredient := $DynamicEgg
var is_mouse_inside:bool = false

func _process(delta):
	if (Input.is_action_just_pressed("left_mouse") && is_mouse_inside):
		ingredient.ingredient_sprite.visible = true
		ingredient.process_mode = Node.PROCESS_MODE_INHERIT
	if (Input.is_action_just_released("left_mouse")):
		ingredient.ingredient_sprite.visible = false
		ingredient.process_mode = Node.PROCESS_MODE_DISABLED


func _on_area_2d_mouse_entered():
	is_mouse_inside = true


func _on_area_2d_mouse_exited():
	is_mouse_inside = false

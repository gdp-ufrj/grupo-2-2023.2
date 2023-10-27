extends Node
@onready var ingredient := $DynamicEgg
var is_mouse_inside:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("left_mouse") && is_mouse_inside):
		ingredient.ingredient_visibility = true
	if (Input.is_action_just_released("left_mouse")):
		ingredient.ingredient_visibility = false
	pass


func _on_area_2d_mouse_entered():
	is_mouse_inside = true
	pass # Replace with function body.


func _on_area_2d_mouse_exited():
	is_mouse_inside = false
	pass # Replace with function body.

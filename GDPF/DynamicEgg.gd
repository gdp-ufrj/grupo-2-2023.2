extends Node2D
@onready var ingredient_name = "Egg"
@onready var cooking_time = 5.0
@onready var initial_position = self.position
@onready var ingredient_visibility = $DynamicEgg.visible

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (ingredient_visibility):
		self.position = get_global_mouse_position()
	pass

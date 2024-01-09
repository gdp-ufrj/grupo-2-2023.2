@tool
class_name IngredientInstantiator extends Node2D

signal ingredient_instantiated(ingredient : DraggableItem)

var DraggableItem = load("res://entities/ingredients/draggable_item.tscn")
	
const collision_box_size = {
	"rice": Vector2(16, 24),
	"beans": Vector2(16, 24),
	"pasta": Vector2(36, 10),
	"salad": Vector2(36, 25),
	"chicken": Vector2(28, 18),
	"egg": Vector2(34, 14)
}

@export_enum(
	"rice", 
	"beans", 
	"pasta", 
	"salad", 
	"chicken", 
	"egg") var ingredient_name : String = "rice":
	set(new_value):
		ingredient_name = new_value
		$AnimatedSprite2D.play(ingredient_name)
		$Area2D/CollisionShape2D.shape.size = collision_box_size[ingredient_name]
		
func _instantiate_ingredient():
	var new_ingredient : DraggableItem = DraggableItem.instantiate()
	new_ingredient.item_name = ingredient_name
	ingredient_instantiated.emit(new_ingredient)
	
func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_mouse"):
			_instantiate_ingredient()

func get_class_name(): return "IngredientInstantiator"

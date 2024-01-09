extends Node2D
class_name ItemGrabber

signal item_dropped(DraggableItem)

var _currently_grabbed_item : DraggableItem = null

func _drop_item():
	item_dropped.emit(_currently_grabbed_item)
	_currently_grabbed_item.queue_free()
	_currently_grabbed_item = null

func _on_ingredient_instantiated(ingredient : DraggableItem):
	if(_currently_grabbed_item != null):
		_currently_grabbed_item.queue_free()
	_currently_grabbed_item = ingredient
	self.add_child(_currently_grabbed_item)

func _ready():
	var ingredient_instantiators = Utils.findByClass(get_tree().get_root(), "IngredientInstantiator") as Array[IngredientInstantiator]
	var ingredient_instantiator: IngredientInstantiator
	for i in ingredient_instantiators.size():
		ingredient_instantiator = ingredient_instantiators[i]
		ingredient_instantiator.ingredient_instantiated.connect(_on_ingredient_instantiated)

func _input(event):
	if event is InputEventMouseMotion:
		# Update the node's position to follow the mouse
		self.global_position = event.position
	if event is InputEventMouseButton:
		if event.is_action_released("left_mouse"):
			if _currently_grabbed_item != null:
				_drop_item()

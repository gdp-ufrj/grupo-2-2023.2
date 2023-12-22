class_name DraggableCookedIngredient
extends Node2D

@onready var _sprite = $Sprite2D
@onready var _initial_position = self.global_position


func _on_grabbed_cooked_ingredient(_ingredient_name):
	if(_ingredient_name == "cooked_chicken"):
		self._sprite.frame = 1
	if(_ingredient_name == "cooked_egg"):
		self._sprite.frame = 4
	self._sprite.visible = true
	self.process_mode = Node.PROCESS_MODE_INHERIT


func _on_released_cooked_ingredient(_ingredient_name, decrease_ingredient):
	self._sprite.visible = false
	self.global_position = _initial_position
	self.process_mode = Node.PROCESS_MODE_DISABLED
	

func _input(event):
	if event is InputEventMouseMotion:
		# Update the node's position to follow the mouse
		self.global_position = event.position


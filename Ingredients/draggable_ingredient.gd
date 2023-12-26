class_name DraggableIngredient
extends Node2D

@onready var _sprite = $Sprite2D
@onready var _initial_position = self.global_position


func _on_ingredient_spawner_ingredient_grabbed():
	self._sprite.visible = true
	self.process_mode = Node.PROCESS_MODE_INHERIT


func _on_ingredient_spawner_ingredient_released(_ingredient, _on_released_inside_callback, _on_released_outside_callback):
	self._sprite.visible = false
	self.global_position = _initial_position
	self.process_mode = Node.PROCESS_MODE_DISABLED
	

func _input(event):
	if event is InputEventMouseMotion:
		# Update the node's position to follow the mouse
		self.global_position = event.position


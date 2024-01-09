@tool
class_name DraggableItem extends Node2D

@export_enum(
	"rice", 
	"beans", 
	"pasta", 
	"salad", 
	"chicken", 
	"egg", 
	"cooked_rice", 
	"cooked_beans", 
	"cooked_pasta", 
	"cooked_chicken", 
	"cooked_egg") var item_name : String = "rice":
	set(new_value):
		item_name = new_value
		$AnimatedSprite2D.play(new_value)


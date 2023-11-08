extends State
class_name OvercookedState

@export var animator: AnimatedSprite2D

@onready var pan : Pan = $"../../"

func _ready():
	pass

func _enter_state():
	print("Entered Overcooked State")

func _exit_state():
	print("Exited Overcooked State")


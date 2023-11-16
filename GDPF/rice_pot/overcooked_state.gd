extends State
class_name OvercookedState

@onready var pan : Pan = $"../../"
@onready var animator: AnimatedSprite2D = pan.get_node("AnimatedSprite2D")

func _ready():
	pass

func _enter_state():
	print("Entered Overcooked State")
	animator.play(get_name())

func _exit_state():
	print("Exited Overcooked State")


extends State
class_name OvercookedState

@onready var _pan : Pan = $"../../"
@onready var _animator: AnimatedSprite2D = _pan.get_node("AnimatedSprite2D")

func _ready():
	pass

func _enter_state():
	print("Entered Overcooked State")
	_animator.play(get_name())

func _exit_state():
	print("Exited Overcooked State")


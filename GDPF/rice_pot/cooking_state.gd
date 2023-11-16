extends State
class_name CookingState

signal cooking_finished

@export var cooking_time: float

@onready var _pan : Pan = $"../../"
@onready var _animator: AnimatedSprite2D = _pan.get_node("AnimatedSprite2D")
@onready var _timer : Timer = _pan.get_node("Timer")

func _ready():
	_timer.timeout.disconnect(_on_timer_timeout)

func _enter_state():
	print("Entered Cooking State")
	_timer.timeout.connect(_on_timer_timeout)
	_timer.wait_time = cooking_time
	_timer.start()
	_animator.play(get_name())
	

func _exit_state():
	print("Exited Cooking State")
	_timer.timeout.disconnect(_on_timer_timeout)

func _on_timer_timeout():
	cooking_finished.emit()

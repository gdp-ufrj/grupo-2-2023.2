extends State
class_name CookedState

signal cooked_finished

@export var animator: AnimatedSprite2D
@export var time_until_overcooked: float

@onready var pan : Pan = $"../../"
@onready var _timer : Timer = pan.get_node("Timer")

func _ready():
	_timer.timeout.disconnect(_on_timer_timeout)

func _enter_state():
	print("Entered Cooking State")
	_timer.timeout.connect(_on_timer_timeout)
	_timer.wait_time = time_until_overcooked
	_timer.start()
	

func _exit_state():
	print("Exited Cooking State")
	_timer.timeout.disconnect(_on_timer_timeout)

func _on_timer_timeout():
	cooked_finished.emit()

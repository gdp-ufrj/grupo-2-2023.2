extends Control

@onready var pedidosText := $Pedidos
@onready var minutesText := $Timer/MinutesTimer
@onready var secondsText := $Timer/SecondsTimer

var time: float = 0.0
var minutes: int = 0
var seconds: int = 0

var msg_queue: Array = [
	"Arroz\nFeijão\nFrango",
	"Arroz\nFrango\nSalada",
	"Arroz\nFeijão\nFrango\nSalada",
	"Omelete\nSalada",
	"Arroz\nFeijão\nFrango",
	"Macarrão\nFeijão\nFrango",
	"Arroz\nFeijão\nFrango\nOmelete\nSalada"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	show_message()

func _input(event):
	
	if event is InputEvent and event.is_action_pressed("ui_accept"):
		show_message()

func show_message() -> void:
	var _msg: String = msg_queue.pop_front()
	pedidosText.text = _msg
	print(msg_queue)

func _process(delta) -> void:
	time += delta
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	minutesText.text = "%02d:" % minutes
	secondsText.text = "%02d" % seconds

func stop() -> void:
	set_process(false)
	
func get_time_formatted() -> String:
	return "%02d:%02d" % [minutes, seconds]

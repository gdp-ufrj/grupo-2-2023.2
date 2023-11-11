extends Control

@onready var pedidosText := $Pedidos
@onready var minutesText := $Timer/MinutesTimer
@onready var secondsText := $Timer/SecondsTimer

var tempo_total : int = 0
var time: float = 0.0
var minutes: int = 0
var seconds: int = 0

var contador_tempo := 0
var contador_score := 0
var contador_tempo_pedidos := 0

var scores: Array

var msg_queue: Array = [
	"Arroz\nFeijão\nFrango",
	"Arroz\nFrango\nSalada",
	"Arroz\nFeijão\nFrango\nSalada",
	"Omelete\nSalada",
	"Arroz\nFeijão\nFrango",
	"Macarrão\nFeijão\nFrango",
	"Arroz\nFeijão\nFrango\nOmelete\nSalada"
]

var time_queue: Array = [
	69, 80,
	91, 102,
	115, 126,
	131, 142,
	169, 180,
	206, 217,
	272, 283
]

var score_queue: Array = [
	12, 10, 7,
	11, 9, 6,
	15, 13, 10,
	6, 4, 1,
	12, 10, 7,
	12, 10, 7,
	18, 16, 13
]

var pedidos_time_queue: Array = [
	57,
	78,
	88,
	110,
	141,
	155,
]

# Called when the node enters the scene tree for the first time.
func _ready():
	inicial_message()

func _input(event):
	
	if event is InputEvent and event.is_action_pressed("ui_accept"):
		show_message()
		get_time()
		get_pontuaçao()
	if event is InputEvent and event.is_action_pressed("ui_right"):
		print("$" , get_totalscore())

func show_message() -> void:
	var _msg: String = msg_queue.pop_front()
	pedidosText.text = pedidosText.text + "\n\n" + _msg
	#print(msg_queue)
	
func inicial_message() -> void:
	var _msg: String = msg_queue.pop_front()
	pedidosText.text = _msg

func _process(delta) -> void:
	time += delta
	tempo_total = int(time)
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	minutesText.text = "%02d:" % minutes
	secondsText.text = "%02d" % seconds
	
	if (tempo_total == pedidos_time_queue[contador_tempo_pedidos]):
		contador_tempo_pedidos += 1
		show_message()

func stop() -> void:
	set_process(false)
	
func get_time_formatted() -> String:
	return "%02d:%02d" % [minutes, seconds]
	
func get_time():
	print(int(time))
	
func get_pontuaçao():
	if(tempo_total < time_queue[contador_tempo]):
		print("$" , score_queue[contador_score])
		scores.append(score_queue[contador_score])
	elif(tempo_total < time_queue[contador_tempo + 1]):
		print("$" , score_queue[contador_score + 1])
		scores.append(score_queue[contador_score + 1])
	else:
		print("$" , score_queue[contador_score + 2])
		scores.append(score_queue[contador_score + 2])
	contador_tempo += 2
	contador_score += 3

func get_totalscore() -> int:
	var score_total: int = 0
	for n in scores.size():
		score_total += scores[n]
	return score_total

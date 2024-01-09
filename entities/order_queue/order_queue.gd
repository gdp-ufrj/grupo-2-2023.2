extends Control

@export var initial_wait_time = 3
@export var max_orders_amount = 5

@export var new_order_audio : AudioStream

@onready var _orders = $Orders
@onready var _timer = $Timer
@onready var _audio : AudioStreamPlayer = $Orders/AudioStreamPlayer

const MAX_INT = 9223372036854775807

var order_scene = preload("res://entities/order_queue/order.tscn")


const mode = {
	"tutorial" = {
		"min_ingredient_amount" = 2,
		"max_ingredient_amount" = 2,
		"min_wait_time" = MAX_INT,
		"max_wait_time" = MAX_INT
	},
	"easy" = {
		"min_ingredient_amount" = 2,
		"max_ingredient_amount" = 3,
		"min_wait_time" = 20,
		"max_wait_time" = 30
	},
	"medium" = {
		"min_ingredient_amount" = 3,
		"max_ingredient_amount" = 6,
		"min_wait_time" = 15,
		"max_wait_time" = 20
	},
	"hard" = {
		"min_ingredient_amount" = 4,
		"max_ingredient_amount" = 6,
		"min_wait_time" = 10,
		"max_wait_time" = 16
	}
}

var _current_difficulty = "tutorial"

func _ready():
	_timer.wait_time = initial_wait_time
	_timer.start()
	
func _new_order():
	var order = order_scene.instantiate() as Order
	order.min_ingredient_amount = mode[_current_difficulty]["min_ingredient_amount"]
	order.max_ingredient_amount = mode[_current_difficulty]["max_ingredient_amount"]
	if(_current_difficulty == "tutorial"):
		order._is_tutorial = true
	_orders.add_child(order)
	var min_time = mode[_current_difficulty]["min_wait_time"]
	var max_time = mode[_current_difficulty]["max_wait_time"]
	var next_wait_time = randf_range(min_time, max_time)
	_timer.wait_time = next_wait_time
	_timer.start()
	_audio.stream = new_order_audio
	_audio.play()
	
func _on_timer_timeout():
	if _orders.get_children().size() < max_orders_amount:
		_new_order()
		
func _on_score_changed(new_score):
	print(_timer.wait_time)
	print(_current_difficulty)
	if _current_difficulty == "tutorial" and new_score > 0 and new_score < 60:
		_current_difficulty = "easy"
		_new_order()
	elif _current_difficulty == "easy" and new_score > 60 and new_score < 200:
		_current_difficulty = "medium"
	elif _current_difficulty == "medium" and new_score > 200:
		_current_difficulty = "hard"
#
#@onready var pedidosText := $Pedidos
#@onready var minutesText := $MinutesTimer
#@onready var secondsText := $SecondsTimer
#
#var tempo_total : int = 0
#var time: float = 0.0
#var minutes: int = 0
#var seconds: int = 0
#
#var contador_tempo := 0
#var contador_score := 0
#var contador_tempo_pedidos := 0
#
#var scores: Array
#
#var msg_queue: Array = [
#	"Arroz\nFeijão\nFrango",
#	"Arroz\nFrango\nSalada",
#	"Arroz\nFeijão\nFrango\nSalada",
#	"Omelete\nSalada",
#	"Arroz\nFeijão\nFrango",
#	"Macarrão\nFeijão\nFrango",
#	"Arroz\nFeijão\nFrango\nOmelete\nSalada"
#]
#
#var time_queue: Array = [
#	69, 80,
#	91, 102,
#	115, 126,
#	131, 142,
#	169, 180,
#	206, 217,
#	272, 283
#]
#
#var score_queue: Array = [
#	12, 10, 7,
#	11, 9, 6,
#	15, 13, 10,
#	6, 4, 1,
#	12, 10, 7,
#	12, 10, 7,
#	18, 16, 13
#]
#
#var pedidos_time_queue: Array = [
#	57,
#	78,
#	88,
#	110,
#	141,
#	155,
#]
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	inicial_message()
#
#func _input(event):
#
#	if event is InputEvent and event.is_action_pressed("ui_accept"):
#		show_message()
#		get_time()
#		get_pontuaçao()
#	if event is InputEvent and event.is_action_pressed("ui_right"):
#		print("$" , get_totalscore())
#
#func show_message() -> void:
#	var _msg: String = msg_queue.pop_front()
#	pedidosText.text = pedidosText.text + "\n\n" + _msg
#	#print(msg_queue)
#
#func inicial_message() -> void:
#	var _msg: String = msg_queue.pop_front()
#	pedidosText.text = _msg
#
#func _process(delta) -> void:
#	time += delta
#	tempo_total = int(time)
#	seconds = fmod(time, 60)
#	minutes = fmod(time, 3600) / 60
#	minutesText.text = "%02d:" % minutes
#	secondsText.text = "%02d" % seconds
#
#	if (tempo_total == pedidos_time_queue[contador_tempo_pedidos]):
#		contador_tempo_pedidos += 1
#		show_message()
#
#func stop() -> void:
#	set_process(false)
#
#func get_time_formatted() -> String:
#	return "%02d:%02d" % [minutes, seconds]
#
#func get_time():
#	print(int(time))
#
#func get_pontuaçao():
#	if(tempo_total < time_queue[contador_tempo]):
#		print("$" , score_queue[contador_score])
#		scores.append(score_queue[contador_score])
#	elif(tempo_total < time_queue[contador_tempo + 1]):
#		print("$" , score_queue[contador_score + 1])
#		scores.append(score_queue[contador_score + 1])
#	else:
#		print("$" , score_queue[contador_score + 2])
#		scores.append(score_queue[contador_score + 2])
#	contador_tempo += 2
#	contador_score += 3
#
#func get_totalscore() -> int:
#	var score_total: int = 0
#	for n in scores.size():
#		score_total += scores[n]
#	return score_total


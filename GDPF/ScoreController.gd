extends Node
class_name ScoreController

signal score_changed(current_score)
signal health_changed(current_score)

signal player_lost(current_score)

var current_score : float = 0

var current_health : float = 5

@onready var _score_label : Label = get_node("%ScoreLabel")
@onready var _health_container : HBoxContainer = get_node("%HealthContainer")

var health_icon_scene = preload("res://order_queue/health_icon.tscn")

func _ready():
	for i in current_health:
		_health_container.add_child(health_icon_scene.instantiate())

func increase_score_by(value: float):
	current_score += value
	_score_label.text = _format_score_label(current_score)
	score_changed.emit(current_score)
	
func decrease_health():
	if current_health > 1:
		current_health -= 1
		_health_container.get_child(0).queue_free()
	else:
		player_lost.emit(current_score)
		print("Player lose")
	
func _format_score_label(score : float):
	return "R$ %.2f" % score

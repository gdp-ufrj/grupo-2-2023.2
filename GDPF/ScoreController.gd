extends Node
class_name ScoreController

signal score_changed(current_score)

var current_score : float = 0

@onready var _score_label : Label = get_node("%ScoreLabel")

func increase_score_by(value: float):
	current_score += value
	_score_label.text = _format_score_label(current_score)
	score_changed.emit(current_score)
	
func _format_score_label(score : float):
	return "R$ %.2f" % score

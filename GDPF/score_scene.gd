extends Node2D

@onready var score_label : Label = get_node("%Score")
	
func _format_score_label(score : float):
	return "R$ %.2f" % score

func _ready():
	score_label.text = str(int(Globals.score))

func _on_button_menu_pressed():
	SceneSwitcher.switch_scene("res://main.tscn")


func _on_button_play_pressed():
	SceneSwitcher.switch_scene("res://main.tscn")

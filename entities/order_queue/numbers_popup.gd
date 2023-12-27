extends Marker2D

@export var money_node : PackedScene

func popup(value):
	var money = money_node.instantiate()
	money.position = global_position
	var label = money.get_node("Label")
	label.text = "R$" + str(value)
	
	var tween = get_tree().create_tween()
	tween.tween_property(money,"position",global_position + Vector2(randi_range(-1,1), randi_range(-1,1)), 0.75)
	get_tree().current_scene.add_child(money)
		
func _get_direction():
	return Vector2(randf_range(-1,1),-randf())*16

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

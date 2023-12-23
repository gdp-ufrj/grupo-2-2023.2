extends Timer
class_name TimerWithRect

@onready var _order : Order = $"../"
@onready var _bg_rect : ColorRect = _order.get_node("BgRect")
@onready var _fill_rect : ColorRect = _order.get_node("BgRect/FillRect")

@export var start_color = Color(0, 1, 0)  # Green
@export var end_color = Color(1, 0, 0)    # Red

func _process(dt):
	_decrease_timer_rect(self.time_left)

func _decrease_timer_rect(wait_time : float):
	var max_size : Vector2 = _bg_rect.get_rect().size
	var lerp_value = self.time_left/self.wait_time
	
	var next_size = Vector2(lerp_value * max_size.x, _fill_rect.get_rect().size.y)
	var interpolated_color = start_color.lerp(end_color, 1.-lerp_value)
	interpolated_color.s *= 100

	_fill_rect.set_size(next_size)
	_fill_rect.color = interpolated_color


class_name FiniteStateMachine
extends State

@export var state: State

func _ready():
	change_state(state)
	pass

func change_state(new_state: State):
	if state is State:
		state._exit_state()
	new_state._enter_state()
	state = new_state
	print(state.name)

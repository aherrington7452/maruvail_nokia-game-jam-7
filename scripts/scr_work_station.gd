extends Node2D

@onready var state_label: AnimatedSprite2D = $StatesLabelOutline/StateLabel
@onready var states_label_outline: AnimatedSprite2D = $StatesLabelOutline

enum State { Work, Coffee, Sleep }

var selection_state_dict = {0:"Work", 1:"Coffee", 2:"Sleep"}
var current_state : State
var selection_state 

func _ready():
	current_state = State.Work
	selection_state = 0

func _process(delta) -> void:
	if Input.is_action_pressed("move_up"):
		if selection_state < 2:
			selection_state += 1
		elif selection_state == 2:
			selection_state = 0
	print("Selection State: ", selection_state)
	if Input.is_action_just_pressed("interact"):
		current_state = selection_state
	print("Current State ", current_state)
"""
	label_animation()

func label_animation():
	# TODO: if selection_state, then if current_state
	if current_state == State.Work:
		state_label.play("pressed")
		state_label.play("default")
		state_label.play("default")
	elif current_state == State.Coffee:
		state_label.play("default")
		state_label.play("pressed")
		state_label.play("default")
	elif current_state == State.Sleep:
		state_label.play("default")
		state_label.play("default")
		state_label.play("pressed")
"""

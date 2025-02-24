extends Node2D

@onready var state_label: AnimatedSprite2D = $StateLabelOutline/StateLabel
@onready var state_label_outline: AnimatedSprite2D = $StateLabelOutline
@onready var work_cat_animation: AnimatedSprite2D = $WorkCat

#dictionary
var State = { "Work": 0, "Coffee": 1, "Sleep": 2 }

var current_state
var current_selection_state

func _ready():
	current_state = State["Work"]
	current_selection_state = State["Work"]

func _process(_delta) -> void:
	if Input.is_action_just_pressed("move_up"):
		if current_selection_state < 2:
			current_selection_state += 1
		elif current_selection_state == 2:
			current_selection_state = 0
	if Input.is_action_just_pressed("move_down"):
		if current_selection_state > 0:
			current_selection_state -= 1
		elif current_selection_state == 0:
			current_selection_state = 2
	if Input.is_action_just_pressed("interact"):
		current_state = current_selection_state
	label_animation()
	cat_animation()

func label_animation():
	if current_selection_state == State.Work:
		state_label.play("work")
		if current_state == State.Work:
			state_label_outline.play("active")
		else:
			state_label_outline.play("inactive")
	elif current_selection_state == State.Coffee:
		state_label.play("coffee")
		if current_state == State.Coffee:
			state_label_outline.play("active")
		else:
			state_label_outline.play("inactive")
	elif current_selection_state == State.Sleep:
		state_label.play("sleep")
		if current_state == State.Sleep:
			state_label_outline.play("active")
		else:
			state_label_outline.play("inactive")

func cat_animation():
	if current_state == State.Work:
		work_cat_animation.play("work")
	elif current_state == State.Coffee:
		work_cat_animation.play("coffee")
	elif current_state == State.Sleep:
		work_cat_animation.play("sleep")

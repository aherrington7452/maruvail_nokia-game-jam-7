extends Node2D

# buttons have "default" and "selected" animations
@onready var button_work: AnimatedSprite2D = $ButtonWork
@onready var button_coffee: AnimatedSprite2D = $ButtonCoffee
@onready var button_sleep: AnimatedSprite2D = $ButtonSleep

enum State { Work, Coffee, Sleep }
var current_state : State

func _ready():
	current_state = State.Work

func _process(delta):
	if Input.is_action_pressed("move_left"):
		current_state = State.Coffee
	elif Input.is_action_pressed("move_right"):
		current_state = State.Sleep
	elif Input.is_action_pressed("move_up"):
		current_state = State.Work
	button_animation()

func button_animation():
	if current_state == State.Work:
		button_work.play("pressed")
		button_coffee.play("default")
		button_sleep.play("default")
	elif current_state == State.Coffee:
		button_work.play("default")
		button_coffee.play("pressed")
		button_sleep.play("default")
	elif current_state == State.Sleep:
		button_work.play("default")
		button_coffee.play("default")
		button_sleep.play("pressed")

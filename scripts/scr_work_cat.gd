extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

enum State { Work, Coffee, Sleep }
var current_state : State

func _ready():
	current_state = State.Work

func _process(_delta):
	if Input.is_action_pressed("move_left"):
		current_state = State.Coffee
	elif Input.is_action_pressed("move_right"):
		current_state = State.Sleep
	elif Input.is_action_pressed("move_up"):
		current_state = State.Work
	cat_animation()

func cat_animation():
	if current_state == State.Work:
		animated_sprite_2d.play("work")
	elif current_state == State.Coffee:
		animated_sprite_2d.play("coffee")
	elif current_state == State.Sleep:
		animated_sprite_2d.play("sleep")

extends Node2D

@onready var stay: AnimatedSprite2D = $stay
@onready var quit: AnimatedSprite2D = $quit
@onready var arrows: AnimatedSprite2D = $arrows

var options = {"Stay": 0, "Quit": 1}
var selection = 0

func _on_text_animation_finished() -> void:
	stay.show()
	quit.show()
	arrows.show()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("move_right"):
		stay.frame = 1
		quit.frame = 1
		selection = options["Quit"]
	elif Input.is_action_just_pressed("move_left"):
		stay.frame = 0
		quit.frame = 0
		selection = options["Stay"]
	if (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("interact2")) and stay.visible == true and quit.visible == true:
		if selection == 0:
			var scene = load("res://scene/intro.tscn").instantiate()
			get_parent().add_child(scene)
			queue_free()
		elif selection == 1:
			#EXITS GAME
			#Have epilogue explaining quitting job?
			get_tree().quit()

extends Node2D

@onready var rejoice: AnimatedSprite2D = $rejoice
@onready var beg: AnimatedSprite2D = $beg
@onready var arrows: AnimatedSprite2D = $arrows

var options = {"Stay": 0, "Quit": 1}
var selection = 0

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("move_right"):
		beg.frame = 1
		rejoice.frame = 1
		selection = options["Quit"]
	elif Input.is_action_just_pressed("move_left"):
		beg.frame = 0
		rejoice.frame = 0
		selection = options["Stay"]
	if (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("interact2")) and beg.visible == true and rejoice.visible == true:
		if selection == 0:
			var scene = load("res://scene/intro.tscn").instantiate()
			get_parent().add_child(scene)
			queue_free()
		elif selection == 1:
			#EXITS GAME
			#Have epilogue explaining quitting job?
			get_tree().quit()

func _on_text_animation_finished() -> void:
	beg.show()
	rejoice.show()
	arrows.show()

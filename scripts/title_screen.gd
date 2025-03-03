extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _process(_delta) -> void:
	if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("interact2"):
		animated_sprite_2d.play("awake")
	if Input.is_action_just_pressed("move_up"):
		animated_sprite_2d.play("sleeping")


func _on_animated_sprite_2d_animation_finished() -> void:
	var scene = preload("res://scene/intro.tscn").instantiate()
	get_parent().add_child(scene)
	queue_free()

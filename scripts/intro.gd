extends Node2D

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("interact2"):
			var scene = preload("res://scene/work_station_ui.tscn").instantiate()
			get_parent().add_child(scene)
			queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	var scene = preload("res://scene/work_station_ui.tscn").instantiate()
	get_parent().add_child(scene)
	queue_free()

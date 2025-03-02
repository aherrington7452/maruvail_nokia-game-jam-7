extends Node2D

var scene = load("res://scene/work_station_ui.tscn")

func _on_heart_animation_finished() -> void:
	$Heart.hide()
	$GameOver.show()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
			#Takes player back to main game scene, skips title and intro
			var instance = scene.instantiate()
			get_parent().add_child(instance)
			queue_free()

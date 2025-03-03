extends Node2D

var scene = load("res://scene/work_station_ui.tscn")
var can_continue : bool = false

func _on_heart_animation_finished() -> void:
	$Heart.hide()
	$GameOver.show()
	can_continue = true

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("interact2")) and can_continue:
			#Takes player back to main game scene, skips title and intro
			var instance = scene.instantiate()
			get_parent().add_child(instance)
			queue_free()

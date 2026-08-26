extends Button

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start"):
		get_tree().change_scene_to_file("res://sceny/main.tscn")


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://sceny/gotcha!.tscn")


	

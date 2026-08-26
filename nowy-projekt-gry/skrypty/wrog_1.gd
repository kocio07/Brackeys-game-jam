extends CharacterBody2D


func _on_death_body_entered(body: Node2D) -> void:
	if body.is_in_group("gracz"):
		respawn_gracz(body)
		
		
func respawn_gracz(body: CharacterBody2D) -> void:
	if Global.checkpoint_pos != Vector2(-999, -999):
		$"ouch sfx".play()
		body.global_position = Global.checkpoint_pos
		body.velocity = Vector2.ZERO
	else:
		get_tree().reload_current_scene()

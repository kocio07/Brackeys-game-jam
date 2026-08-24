extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("gracz"):
		Global.checkpoint_pos = $Marker2D.global_position
		
		

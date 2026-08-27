
extends Area2D

func _ready() -> void:
	$Label.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("gracz"):
		respawn_gracz(body)
		$Label.visible = true
		
		
		
func respawn_gracz(body: CharacterBody2D) -> void:
	if Global.checkpoint_pos != Vector2(-999, -999):
		body.global_position = Global.checkpoint_pos
		body.velocity = Vector2.ZERO
	else:
		get_tree().reload_current_scene()  #tutaj dalem ze jak nie ma checkpoint to reload sceny mozna to zmienic
	
	
	

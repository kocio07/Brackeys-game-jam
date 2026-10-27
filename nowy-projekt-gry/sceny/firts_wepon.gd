extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	start_jumping()

func start_jumping() -> void:
	var base_y = animated_sprite.position.y
	
	var tween = create_tween().set_loops()
	tween.tween_property(animated_sprite, "position:y", base_y - 10, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(animated_sprite, "position:y", base_y, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_interval(0.3)

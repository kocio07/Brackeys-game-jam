extends Area2D

@export var speed: float = 400.0
@export var max_range: float = 200.0
var direction: int = -1
var start_position: Vector2

func _ready() -> void:
	start_position = global_position
	if direction == 1:
		$"Bullet".flip_h = true
	else:
		$"Bullet".flip_h = false

func _physics_process(delta: float) -> void:
	position.x += direction * speed * delta
	if global_position.distance_to(start_position) >= max_range:
		visible = false
		$CollisionShape2D.disabled = true
		await $AudioStreamPlayer2D.finished
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("gracz"):
		var anim_sprite = body.get_node_or_null("AnimatedSprite2D")
		anim_sprite.play("Death")
		if body.has_method("set_physics_process"):
			body.set_physics_process(false)
		await anim_sprite.animation_finished
		anim_sprite.play("Idle")
		if body.has_method("set_physics_process"):
			body.set_physics_process(true)
		Global.dead_counter += 1
		if Global.checkpoint_pos != Vector2(-999, -999):
			body.global_position = Global.checkpoint_pos
			body.velocity = Vector2.ZERO
		else:
			get_tree().reload_current_scene()
		visible = false
		await $AudioStreamPlayer2D.finished
		queue_free()

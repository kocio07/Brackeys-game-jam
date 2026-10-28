extends Area2D

@export var speed: float = 400.0
@export var max_range: float = 100.0
var direction: int = 1
var start_position: Vector2

func _ready() -> void:
	start_position = global_position
	if direction == -1:
		$"Bullet".flip_h = false
	else:
		$"Bullet".flip_h = true

func _physics_process(delta: float) -> void:
	position.x += direction * speed * delta
	if global_position.distance_to(start_position) >= max_range:
		visible = false
		$CollisionShape2D.disabled = true
		await $AudioStreamPlayer2D.finished
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("gracz"):
		return
	if body.is_in_group("wrog"):
		body.queue_free()
	visible = false
	await $AudioStreamPlayer2D.finished
	queue_free()

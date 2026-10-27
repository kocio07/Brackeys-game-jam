extends Area2D

@export var speed: float = 400.0
var direction: int = 1

func _ready() -> void:
	if direction == -1:
		$"Bullet".flip_h = false
	else:
		$"Bullet".flip_h = true

func _physics_process(delta: float) -> void:
	position.x += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("gracz"):
		return
	queue_free()

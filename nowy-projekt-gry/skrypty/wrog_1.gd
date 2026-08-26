extends CharacterBody2D

@export_group("Movement")
@export var speed: float = 80.0
@export var gravity: float = 980.0
@export var start_facing_left: bool = false

var direction: int = 1

@onready var edge_detector: RayCast2D = $EdgeDetector

func _ready() -> void:
	if start_facing_left:
		direction = -1
		scale.x = -abs(scale.x)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if is_on_wall() or not edge_detector.is_colliding():
			flip()
	
	velocity.x = direction * speed
	move_and_slide()

func flip() -> void:
	direction *= -1
	scale.x *= -1
	edge_detector.force_raycast_update()


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


func _on_weak_body_entered(body: Node2D) -> void:
	if body.is_in_group("gracz"):
		if body.has_method("bounce"):
			body.bounce()
		queue_free()

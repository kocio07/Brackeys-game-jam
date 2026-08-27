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
	if is_dead:
		velocity.y += gravity * delta
		move_and_slide()
		return
		
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
		defeat()
		
var is_dead: bool = false

func defeat() -> void:
	if is_dead:
		return
	is_dead = true
	
	$CollisionShape2D.set_deferred("disabled", true)
	$weak/CollisionShape2D2.set_deferred("disabled", true)
	$death/CollisionShape2D.set_deferred("disabled", true)
	if has_node("text/CollisionShape2D"):
		$text/CollisionShape2D.set_deferred("disabled", true)
	scale.y = -scale.y
	velocity.y = -200.0
	get_tree().create_timer(2.0).timeout.connect(queue_free)


func _on_text_body_entered(_body: Node2D) -> void:
	var parent = get_parent()
	if parent.has_node("Label7"):
		parent.get_node("Label7").visible = true

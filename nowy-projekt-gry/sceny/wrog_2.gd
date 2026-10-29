extends CharacterBody2D

@onready var muzzle: Marker2D = $Marker2D
@export var bullet_scene: PackedScene
@export var fire_rate: float = 2.0
var _shoot_timer = 0

func _process(delta: float) -> void:
	if _shoot_timer > 0.0:
		_shoot_timer -= delta
	if _shoot_timer <= 0.0:
		try_to_shoot()
		_shoot_timer = fire_rate
func try_to_shoot() -> void:
	shoot_level_one()
		
func shoot_level_one() -> void:
	if bullet_scene:
		$AnimatedSprite2D.play("default")
		await $AnimatedSprite2D.animation_finished
		var bullet = bullet_scene.instantiate() as Node2D
		bullet.global_position = muzzle.global_position
		
		get_tree().current_scene.add_child(bullet)

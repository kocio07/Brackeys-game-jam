extends CharacterBody2D 

@export var speed = 155
@export var gravity = 1000
@export var jump_force = 183
@export var weapon_speed = 200.0
@export var direction = 1
@export var bullet_scene: PackedScene

@onready var color_rect = $CanvasLayer2/ColorRect
@onready var muzzle: Marker2D = $Muzzle

func _ready() -> void:
	if Global.checkpoint_pos != Vector2(-999, -999):
		global_position = Global.checkpoint_pos
	await teleport_with_effect_out()
	
func _physics_process(delta: float) -> void:
	direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * speed
		if is_on_floor():
			$AnimatedSprite2D.play("Run")
	else:
		velocity.x = 0
		if is_on_floor():
			$AnimatedSprite2D.play("Idle")
		
	# Obracanie duszka
	if direction == 1:
		$AnimatedSprite2D.flip_h = false
	elif direction == -1:
		$AnimatedSprite2D.flip_h = true
		
	# Grawitacja
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Skok
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= jump_force
		$"Skok sfx".play()
		$AnimatedSprite2D.play("Jump")
		
	move_and_slide()

func _on_next_level_body_entered(body: Node2D) -> void:
	await teleport_with_effect_in()
	get_tree().change_scene_to_file("res://sceny/level_2.tscn")
	
func teleport_with_effect_in():
	var material = color_rect.material as ShaderMaterial
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/progress", 1.0, 1.0)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
	await tween.finished

func teleport_with_effect_out():
	var material = color_rect.material as ShaderMaterial
	var tween_out = create_tween()
	tween_out.tween_property(material, "shader_parameter/progress", 0.0, 1.0)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
	await tween_out.finished
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		try_to_shoot()
		
func try_to_shoot() -> void:
	if Global.has_weapon == true:
		if Global.weapon == 1:
			shoot_level_one()
		elif Global.weapon == 0:
			pass
	else:
		pass
		
func shoot_level_one() -> void:
	var shoot_dir = 1
	if $AnimatedSprite2D.flip_h:
		shoot_dir = -1
		muzzle.position.x = -18
	else:
		shoot_dir = 1
		muzzle.position.x = 18
		
	if bullet_scene:
		var bullet = bullet_scene.instantiate() as Node2D
		bullet.global_position = muzzle.global_position
		bullet.direction = shoot_dir
		
		get_tree().current_scene.add_child(bullet)

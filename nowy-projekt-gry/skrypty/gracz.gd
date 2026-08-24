extends CharacterBody2D 
@export var speed = 155
@export var gravity = 1000
@export var jump_force = 183

func _ready() -> void:
	if Global.checkpoint_pos != Vector2(-999, -999):
		global_position = Global.checkpoint_pos
	
func _physics_process(delta: float) -> void:
	
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * speed
		if is_on_floor():
			$AnimatedSprite2D.play("Run")
	else:
		velocity.x = 0
		if is_on_floor():
			$AnimatedSprite2D.play("Idle")
		
	#Obracanie duszka
	
	if direction == 1:
		$AnimatedSprite2D.flip_h = false
	elif direction == -1:
		$AnimatedSprite2D.flip_h = true
		
		
	#Grawitacja
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#Skok
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		
		velocity.y -= jump_force
		$AnimatedSprite2D.play("Jump")
		
	move_and_slide()

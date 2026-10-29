extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = -450.0
@export var gravity: float = 1200.0

var max_hp: int = 200
var current_hp: int = 200

enum Phase {PHASE_1, PHASE_2, PHASE_3}
var current_phase = Phase.PHASE_1

var action_timer: Timer
var target_player: Node2D = null

func _ready() -> void:
	Global.boss_max_hp = max_hp
	Global.boss_current_hp = current_hp
	current_hp = max_hp
	
	if get_tree().has_group("gracz"):
		target_player = get_tree().get_first_node_in_group("gracz")
	
	action_timer = Timer.new()
	action_timer.wait_time = 2.0
	action_timer.autostart = true
	action_timer.one_shot = false
	action_timer.timeout.connect(_on_action_timer_timeout)
	add_child(action_timer)
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	update_boss_phases()
	check_player_collision()
	move_and_slide()
	
func update_boss_phases() -> void:
	Global.boss_current_hp = current_hp
	
	if current_hp <= 70 and current_phase != Phase.PHASE_3:
		current_phase = Phase.PHASE_3
		speed = 300.0
		action_timer.wait_time = 1.2
	elif current_hp <= 140 and current_hp > 70 and current_phase != Phase.PHASE_2:
		current_phase = Phase.PHASE_2
		speed = 240.0
		action_timer.wait_time = 1.6
		
func _on_action_timer_timeout() -> void:
	if not target_player:
		if get_tree().has_group("gracz"):
			target_player = get_tree().get_first_node_in_group("gracz")
		return
	var roll = randi() % 3
	
	match current_phase:
		Phase.PHASE_1:
			if is_on_floor():
				var direction = sign(target_player.global_position.x - global_position.x)
				velocity.x = direction * (speed * 0.75)
				velocity.y = jump_force * 0.8
		Phase.PHASE_2:
			if is_on_floor():
				var direction = sign(target_player.global_position.x - global_position.x)
				velocity.x = direction * speed
				velocity.y = jump_force
		Phase.PHASE_3:
			if is_on_floor():
				var direction = sign(target_player.global_position.x - global_position.x)
				velocity.x = direction * (speed * 1.4)
				velocity.y = jump_force * 1.1

# I need to call this function in bullet script
func take_damage(amount: int) -> void:
	current_hp -= amount
	Global.boss_current_hp = current_hp
	
	modulate = Color(1, 0.3, 0.3)
	await  get_tree().create_timer(0.1).timeout
	modulate = Color(1, 1, 1)
	
	if current_hp <= 0:
		die()
		
func die() -> void:
	Global.boss_current_hp = 0
	queue_free()
	
func check_player_collision() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider.is_in_group("gracz"):
			trigger_player_death(collider)
			
func trigger_player_death(player_node: Node2D) -> void:
	set_physics_process(false)
	var tree = Engine.get_main_loop() as SceneTree
	if tree:
		tree.reload_current_scene()

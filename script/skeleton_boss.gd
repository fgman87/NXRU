extends CharacterBody2D
 
@onready var player = get_parent().find_child("player")
@onready var animated_sprite = $AnimatedSprite2D
@onready var progress_bar = $UI/ProgressBar
var max_health = 0
var current_health = 0
var direction : Vector2
func _ready():
	set_physics_process(false)
	max_health = 100 + (100 * (global.current_level_num * .1))
	progress_bar.max_value = max_health
	current_health = max_health
	progress_bar.value = max_health
	print("Boss Max HP: ", progress_bar.max_value)
	
func _process(_delta):
	direction = player.position - position
 
	if direction.x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
 
func _physics_process(delta):
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)
 
func player_hit():
	player.HP -= 10
	print(player.HP)

func take_damage():
	current_health -= global.player_arrowDam
	progress_bar.value = current_health
	player.get_sp()
	print("Boss Max HP: ", progress_bar.max_value, " Boss Current HP: ", progress_bar.value)
	if current_health <= 0:
		progress_bar.visible = false
		find_child("FiniteStateMachine").change_state("Death")
		set_physics_process(false)
		await get_tree().create_timer(3.5).timeout
		player.current_xp += 500 + (500 * (global.current_level_num * .07))
		global.player_xp += 500 + (500 * (global.current_level_num * .07))
		global.total_xp += 500 + (500 * (global.current_level_num * .07))
		global.get_mob_count()
		queue_free()
		
func take_fire_damage():
	current_health -= 30
	progress_bar.value = current_health
	print("Boss Max HP: ", progress_bar.max_value, " Boss Current HP: ", progress_bar.value)
	await get_tree().create_timer(1).timeout
	current_health -= 5
	progress_bar.value = current_health
	print("Boss Max HP: ", progress_bar.max_value, " Boss Current HP: ", progress_bar.value)
	await get_tree().create_timer(1).timeout
	current_health -= 5
	progress_bar.value = current_health
	print("Boss Max HP: ", progress_bar.max_value, " Boss Current HP: ", progress_bar.value)
	await get_tree().create_timer(1).timeout
	current_health -= 12
	progress_bar.value = current_health
	print("Boss Max HP: ", progress_bar.max_value, " Boss Current HP: ", progress_bar.value)
	if current_health <= 0:
		progress_bar.visible = false
		find_child("FiniteStateMachine").change_state("Death")
		set_physics_process(false)
		await get_tree().create_timer(3.5).timeout
		player.current_xp += 500 + (500 * (global.current_level_num * .07))
		global.player_xp += 500 + (500 * (global.current_level_num * .07))
		global.total_xp += 500 + (500 * (global.current_level_num * .07))
		global.get_mob_count()
		queue_free()


func take_fire2_damage():
	current_health -= 40
	progress_bar.value = current_health
	print("Boss Max HP: ", progress_bar.max_value, " Boss Current HP: ", progress_bar.value)
	await get_tree().create_timer(1).timeout
	current_health -= 12
	progress_bar.value = current_health
	print("Boss Max HP: ", progress_bar.max_value, " Boss Current HP: ", progress_bar.value)
	if current_health <= 0:
		progress_bar.visible = false
		find_child("FiniteStateMachine").change_state("Death")
		set_physics_process(false)
		await get_tree().create_timer(3.5).timeout
		player.current_xp += 500 + (500 * (global.current_level_num * .07))
		global.player_xp += 500 + (500 * (global.current_level_num * .07))
		global.total_xp += 500 + (500 * (global.current_level_num * .07))
		global.get_mob_count()
		queue_free()

extends CharacterBody2D

var speed = 400 + (400 * (global.current_level_num * .4))
var health = 35 + (35 * (global.current_level_num * .1))
var can_take_damage = true
 
@onready var player = get_parent().find_child("player")
@onready var animation = $AnimatedSprite2D
func _on_player_added(player_node):
	player = player_node

func _on_player_removed(player_node):
	player = null 
func _physics_process(_delta):
	var direction = player.position - position
	velocity = direction.normalized() * 60
	move_and_slide()
	$AnimatedSprite2D.play("walk")

func take_damage():
	health -= global.player_arrowDam
	if health <= 0:
		player.current_xp += 100 + (100 * (global.current_level_num * .07))
		global.player_xp += 100 + (100 * (global.current_level_num * .07))
		global.total_xp += 100 + (100 * (global.current_level_num * .07))
		global.get_mob_count()
		print(global.enemy_count)
		self.queue_free()
	player.get_sp()
	print("Resource: ",player.sp_player)
	#global.popup(global_position)
	can_take_damage = false
		

func _ready():
	start_chasing_player()

func start_chasing_player():
	player = get_tree().get_first_node_in_group("player")
	if player:
		set_process(true)


func enemy():
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		can_take_damage = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		can_take_damage = false


func take_fire_damage():
	health -= 30
	await get_tree().create_timer(1).timeout
	health -= 5
	await get_tree().create_timer(1).timeout
	health -= 5
	await get_tree().create_timer(1).timeout
	health -= 12

func _on_take_damage_cooldown_timeout():
	can_take_damage = true


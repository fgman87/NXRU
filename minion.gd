extends CharacterBody2D
 
@onready var player = get_parent().find_child("player")
@onready var animation = $AnimatedSprite2D
var health = 100
func _ready():
	set_physics_process(false)
	await animation.animation_finished
	set_physics_process(true)
	animation.play("idle")
 
func _physics_process(_delta):
	var direction = player.position - position
	velocity = direction.normalized() * 60
	move_and_slide()
 
func take_damage():
	health -= global.player_arrowDam
	player.get_sp()
	if health <= 0:
		animation.play("death")
		set_physics_process(false)
		await animation.animation_finished
		queue_free()

func take_fire_damage():
	health -= 30
	print("health")
	await get_tree().create_timer(1).timeout
	health -= 5
	await get_tree().create_timer(1).timeout
	health -= 5
	await get_tree().create_timer(1).timeout
	health -= 12
	print("health")

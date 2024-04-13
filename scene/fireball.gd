extends Area2D

var speed = 200
var current_attack = null
func _ready():
	get_anim()
	set_as_top_level(true)

func _process(delta):
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta
 
func get_anim():
	if global.lastshot == "fire":
		$AnimatedSprite2D.play("fire")
		current_attack = "fire"
		global.lastshot = null
	if global.lastshot == "fire2":
		$AnimatedSprite2D.play("fire2")
		current_attack = "fire2"
		global.lastshot = null
	if global.lastshot == "arrow":
		$AnimatedSprite2D.play("arrow")
		global.lastshot = null
		current_attack = "arrow"
	if global.lastshot == "poison":
		$AnimatedSprite2D.play("poison")
		current_attack = "poison"
		global.lastshot = null
	if global.lastshot == "ice":
		$AnimatedSprite2D.play("ice")
		global.lastshot = null
		current_attack = "ice"


func _on_body_entered(body):
	if current_attack == "fire":
		body.take_fire_damage()
		queue_free()
		global.pyro += 1
	if current_attack == "arrow":
		body.take_damage()
		queue_free()
		global.archer += 1
	if current_attack == "fire2":
		body.take_fire2_damage()
		queue_free()
		global.pyro += 1
 
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

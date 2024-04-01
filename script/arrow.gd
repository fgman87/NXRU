extends Area2D

var speed = 300

func _ready():
	set_as_top_level(true)

func _process(delta):
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	print("hihi")
	queue_free()
	if body.has_method("SkeletonBoss"):
		var enemy = body
		body.take_damage()
		print(body.health)
		queue_free()
	if body.has_method("enemy"):
		var enemy = body  # Assign the collided body to the local variable
		enemy.arrow_hit = true
		print("+1 arch xp")
		enemy.health -= 20
		queue_free()

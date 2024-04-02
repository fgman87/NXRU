extends Area2D

var speed = 200

func _ready():
	$AnimatedSprite2D.play("default")
	set_as_top_level(true)

func _process(delta):
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta
 
 
func _on_body_entered(body):
	body.take_fire_damage()
	queue_free()
 
 
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

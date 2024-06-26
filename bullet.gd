extends Area2D

var speed = 300

func _ready():
	set_as_top_level(true)

func _process(delta):
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta
 
 
func _on_body_entered(body):
	body.take_damage()
	body.popup()
	queue_free()
 
 
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

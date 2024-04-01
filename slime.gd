extends CharacterBody2D
func _physics_process(delta): position += (get_parent().get_node("player").position).normalized()* 0.7

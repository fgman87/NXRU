extends Marker2D
@export var damage_node : PackedScene


func _ready():
#	damage = global.player_arrowDam
	randomize()
#var damage : int : 
#	set(value):
#		damage = value
#		%floatText.text = str(value)
func popup():
	var damage = damage_node.instantiate()
	damage.position = global_position
	
	var tween = get_tree().create_tween()
	tween.tween_property(damage, 
	"position", global_position + _get_direction(),
	 0.75)
	
	get_tree().current_scene.add_child(damage)
	
	
func _get_direction():
	return Vector2(randf_range(1,1), -randf() * 16)

func _input(event):
	if Input.is_action_just_pressed("test"):
		popup()

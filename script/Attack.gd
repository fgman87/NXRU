extends State
 
func enter():
	super.enter()
	combo()
 
func attack(move = "1"):
	animation_player.play("attack_" + move)
	await get_tree().create_timer(1).timeout
	if owner.direction.length() < 40:
		owner.player_hit()
	await animation_player.animation_finished
 
 
func combo():
	var move_set = ["1","1","2"]
	for i in move_set:
		await attack(i)
		if owner.direction.length() < 40:
			owner.player_hit()
			await animation_player.animation_finished
 
	combo()
 
func transition():
	if owner.direction.length() > 40:
		get_parent().change_state("Follow")

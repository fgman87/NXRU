extends Node

#equip stuff
var lastshot = null
var bow_equipped = false
var bow_cooldown = true
var sword_equipped = false
var sword_cooldown = true
var lightning_equipped = false
var lightning_cooldown = true
var fire_equipped = false
var fire_cooldown = true
var arrow_hit = false
var fire_hit = false
#end of equip stuff
#scene stuff
var mobs_needed = 1
var current_level_num = 1
var current_scene = 0
#end ofscene stuff
#player stuff
var agility = 5
var player_arrowDam = 10 + floor(.3 * agility)
var player_xp = 0
var player_HP = 100
var player_level = 1
var strength = 5
var vitality = 5
var defense = 5
var enemy_count = 0
var player_current_attack = false
var total_xp = 0
var player_hit
#end of player stuff
#skill increase
var pyro = 1
var archer = 1


func get_mob_count():
	enemy_count += 1
	if current_scene == 0 and enemy_count == mobs_needed:
		change_scene()
		current_level_num += 1
		enemy_count = 0
	if current_scene == 1 and enemy_count == 1:
		change_scene()
		current_level_num += 1
		enemy_count = 0

func get_mobs():
	mobs_needed = current_level_num * 1

func change_scene():
	get_mobs()
	print("Kills needed: ", mobs_needed)
	if current_scene == 0:
		get_mobs()
		print("Kills needed: ", mobs_needed)
		get_tree().call_deferred("change_scene_to_file", "res://scene/boss_world.tscn")
		current_scene = 1
	elif current_scene == 1:
		get_mobs()
		print("Kills needed: ", mobs_needed)
		get_tree().call_deferred("change_scene_to_file", "res://scene/world.tscn")
		current_scene = 0


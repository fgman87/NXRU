extends CharacterBody2D
@export var bullet_node: PackedScene
const XP_DATABASE = "res://Utility/Database.json"
const MAX_LEVEL = 10
@onready var progress_bar = $ProgressBar
@onready var resource_bar = $Resource
var XP_Table_Data = {}

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var player_alive = true
var is_attacking = false
var speed = 500
var dashing = false
var dash_cd = true
var player_state
var sp_player = 0
var dex = 20
var arrowDam = 35
@export var inv: Inv

var bow_equipped = false
var bow_cooldown = true
var sword_equipped = false
var sword_cooldown = true

var fireball = preload("res://scene/fireball.tscn")
var arrow = preload("res://scene/arrow.tscn")
var mouse_loc_from_player = null

var Level : int = 1:
	set(value):
		Level = value
		%Label.text = str(value)

var current_xp = global.player_xp:
	set(value):
		current_xp = value
		var max_xp = get_max_xp_at(Level)
		
		if current_xp >= max_xp and Level < MAX_LEVEL:
			global.player_level += 1
			Level += 1
			HP += 20
			global.player_HP = HP
			global.strength += 1
			global.vitality += 1
			global.agility += 3
			Defense += 1
			current_xp -= max_xp
			global.player_xp -= max_xp
		elif Level == MAX_LEVEL:
			current_xp = 0
			
			
		var total = min( (XP_Table_Data[str(Level)]["total"] + current_xp), XP_Table_Data[str(MAX_LEVEL)]["total"] )
		%TotalXP.text = str(total)
			
		%ProgressBar.max_value = get_max_xp_at(Level)
		%ProgressBar.value = current_xp

var HP : int : 
	set(value):
		HP = value
		%HP.text = str(value)

var Vitality : int : 
	set(value):
		Vitality = value
		HP += floor(10 * (Vitality/4))
		%Vitality.text = str(value)

var Strength : int : 
	set(value):
		Strength = value
		%Strength.text = str(value)
		
var Agility : int : 
	set(value):
		Agility = value
		%Agility.text = str(value)
		

var Defense : int : 
	set(value):
		Defense = value
		%Defense.text = str(value)

func get_sp():
	sp_player += 20
	resource_bar.value += 20
func _ready():
	XP_Table_Data = get_xp_data()
	Strength = global.strength
	Agility = global.agility
	Vitality = global.vitality 
	Defense = global.defense
	HP = global.player_HP
	var max_hp = HP
	current_xp = global.player_xp
	Level = global.player_level
	progress_bar.max_value = max_hp
	progress_bar.value = HP
	#print(global.player_xp)
#	print("Player LvL: ",global.player_level, " Player Agility: ", global.agility)
#	print("+100 xp! Player Current XP:", current_xp, "     ", global.player_xp)
#	print("Current Level: ", global.current_level_num, " Kills Needed: ", global.mobs_needed)
#	print("Current Scene: ", global.current_scene)
#	print(XP_Table_Data)

func get_xp_data() -> Dictionary:
	var file = FileAccess.open(XP_DATABASE, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	return data
	
func get_max_xp_at(Level):
	return XP_Table_Data[str(Level)]["need"]


func _physics_process(delta):
	mouse_loc_from_player = get_global_mouse_position() - self.position
	enemy_attack()
	if HP <= 0:
		player_alive = false # add end screen and death animation
		HP = 0
		speed = 0
		print("player has been killed")
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x == 0 and direction.y  == 0:
		player_state = "idle"
	elif direction.x != 0 or direction.y !=0:
		player_state = "walking"
			
	velocity = direction * speed
	move_and_slide()
	if Input.is_action_just_pressed("dash") and !is_attacking and dash_cd:
		dashing = true
		dash_cd = false
		await get_tree().create_timer(3.0).timeout
		dash_cd = true
	if Input.is_action_just_pressed("bow"):
		if bow_equipped:
			bow_equipped = false
			print("bow uneq")
		else:
			bow_equipped = true
			print("bow eq")
			sword_equipped = false
			global.lightning_equipped = false
			global.fire_equipped = false
	if Input.is_action_just_pressed("sword"):
		if sword_equipped:
				sword_equipped = false
				print("sword uneq")
		else:
			sword_equipped = true
			print("sword eq")
			bow_equipped = false
			global.lightning_equipped = false
			global.fire_equipped = false
			
	if Input.is_action_just_pressed("multishot"):
		global.lastshot = "poison"
		speed = 0
		bow_cooldown = false
		is_attacking = true
		await get_tree().create_timer(0.2).timeout
		var fire = fireball.instantiate()
		print("pew")
		fire.rotation = $Marker2D.rotation
		fire.global_position = $Marker2D.global_position
		add_child(fire)
		await get_tree().create_timer(0.3).timeout
		is_attacking = false
		speed = 100
		bow_cooldown = true
		#change to button soonish?!?!? idk read more
			
	if Input.is_action_just_pressed("singleshot"):
		global.lastshot = "fire2"
		speed = 0
		bow_cooldown = false
		is_attacking = true
		await get_tree().create_timer(0.2).timeout
		var fire = fireball.instantiate()
		print("pew")
		fire.rotation = $Marker2D.rotation
		fire.global_position = $Marker2D.global_position
		add_child(fire)
		await get_tree().create_timer(0.3).timeout
		is_attacking = false
		speed = 100
		bow_cooldown = true
		#change to button soonish?!?!? idk read more

	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("left_mouse") and bow_equipped and bow_cooldown:
		speed = 0
		bow_cooldown = false
		is_attacking = true
		global.lastshot = "arrow"
		await get_tree().create_timer(0.2).timeout
		var fire = fireball.instantiate()
		print("pew")
		fire.rotation = $Marker2D.rotation
		fire.global_position = $Marker2D.global_position
		add_child(fire)
		await get_tree().create_timer(0.3).timeout
		is_attacking = false
		speed = 100
		bow_cooldown = true
		#change to button soonish?!?!? idk read more

	if Input.is_action_just_pressed("fireball") and sp_player >=0  and global.fire_cooldown:
		speed = 0
		resource_bar.value = 0
		is_attacking = true
		global.lastshot = "fire"
		global.fire_cooldown = false
		await get_tree().create_timer(0.2).timeout
		var fire = fireball.instantiate()
		print("pew")
		fire.rotation = $Marker2D.rotation
		fire.global_position = $Marker2D.global_position
		add_child(fire)
		await get_tree().create_timer(0.3).timeout
		is_attacking = false
		speed = 100
		global.fire_cooldown = true
	
	if Input.is_action_just_pressed("left_mouse") && sword_equipped and sword_cooldown:
		sword_cooldown = false
		speed = 0
		global.player_current_attack = true
		is_attacking = true
		await get_tree().create_timer(0.5).timeout
		speed = 100
		is_attacking = false
		
		sword_cooldown = true
		

	play_anim(direction)
	
func play_anim(dir):
	if dashing:
		speed = 300
		await get_tree().create_timer(0.3).timeout
		speed = 100
		dashing = false
		
	if !is_attacking:
		if player_state == "idle":
			$AnimatedSprite2D.play('idle')
		if player_state == "walking" and !is_attacking:
			if dir.y == -1:
				$AnimatedSprite2D.play("n-walk")
			if dir.x == 1:
				$AnimatedSprite2D.play("e-walk")
			if dir.y == 1:
				$AnimatedSprite2D.play("s-walk")
			if dir.x == -1:
				$AnimatedSprite2D.play("w-walk")
			
			if dir.x > 0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("se-walk")
			if dir.x > 0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("ne-walk")
			if dir.x < -0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("sw-walk")
			if dir.x < -0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("nw-walk")

					
	if bow_equipped and is_attacking:
		speed = 0
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y < 0:
			$AnimatedSprite2D.play("n-attack")
		if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x > 0:
			$AnimatedSprite2D.play("e-attack")
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y > 0:
			$AnimatedSprite2D.play("s-attack")
		if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x < 0:
			$AnimatedSprite2D.play("w-attack")
			
		if mouse_loc_from_player.x >= 25 and mouse_loc_from_player.y <= -25:
			$AnimatedSprite2D.play("ne-attack")
		if mouse_loc_from_player.x >= 0.5 and mouse_loc_from_player.y >= 25:
			$AnimatedSprite2D.play("se-attack")
		if mouse_loc_from_player.x <= -0.5 and mouse_loc_from_player.y >= 25:
			$AnimatedSprite2D.play("sw-attack")
		if mouse_loc_from_player.x <= -25 and mouse_loc_from_player.y <= -25:
			$AnimatedSprite2D.play("nw-attack")
			
	if sword_equipped and is_attacking:
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y < 0:
			$AnimatedSprite2D.play("n-sattack")
		if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x > 0:
			$AnimatedSprite2D.play("e-sattack")
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y > 0:
			$AnimatedSprite2D.play("s-sattack")
		if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x < 0:
			$AnimatedSprite2D.play("w-sattack")
			
		if mouse_loc_from_player.x >= 25 and mouse_loc_from_player.y <= -25:
			$AnimatedSprite2D.play("ne-sattack")
		if mouse_loc_from_player.x >= 0.5 and mouse_loc_from_player.y >= 25:
			$AnimatedSprite2D.play("se-sattack")
		if mouse_loc_from_player.x <= -0.5 and mouse_loc_from_player.y >= 25:
			$AnimatedSprite2D.play("sw-sattack")
		if mouse_loc_from_player.x <= -25 and mouse_loc_from_player.y <= -25:
			$AnimatedSprite2D.play("nw-sattack")
			
	if global.fire_equipped and is_attacking:
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y < 0:
			$AnimatedSprite2D.play("n-sattack")
		if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x > 0:
			$AnimatedSprite2D.play("e-sattack")
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y > 0:
			$AnimatedSprite2D.play("s-sattack")
		if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x < 0:
			$AnimatedSprite2D.play("w-sattack")
			
		if mouse_loc_from_player.x >= 25 and mouse_loc_from_player.y <= -25:
			$AnimatedSprite2D.play("ne-sattack")
		if mouse_loc_from_player.x >= 0.5 and mouse_loc_from_player.y >= 25:
			$AnimatedSprite2D.play("se-sattack")
		if mouse_loc_from_player.x <= -0.5 and mouse_loc_from_player.y >= 25:
			$AnimatedSprite2D.play("sw-sattack")
		if mouse_loc_from_player.x <= -25 and mouse_loc_from_player.y <= -25:
			$AnimatedSprite2D.play("nw-sattack")

func player():
	pass

func collect(item):
	inv.insert(item)


func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true
	


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false
		
func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown:
		HP = HP - 20 + (20 *global.current_level_num * .2)
		progress_bar.value = HP
		enemy_attack_cooldown = false
		$"attack-cooldown".start()
		print(HP)

func _on_attackcooldown_timeout():
	enemy_attack_cooldown = true


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	is_attacking = true


func _on_gain_xp_pressed():
	current_xp += 100

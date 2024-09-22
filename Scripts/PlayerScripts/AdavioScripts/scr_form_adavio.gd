#Form 1: Adavio
#
extends Form
#
#Built-In Methods
#
func _ready() -> void:
	form_id = 1
	form_swap_in()
	form_player_signal_connections()
	#player = get_parent()
	#special.parent = self
	special.player = player
#
func _physics_process(delta) -> void:
	form_swap_process()
	adavio_roll()
	adavio_melee()
	adavio_magic()
	adavio_special()
	adavio_base()
#
#Custom Methods
#
func adavio_roll() -> void:
	#form_roll_input()
	if is_roll == true:
		animations.play("anim_adavio_roll_" + last_dir)
		await animations.animation_finished
		emit_signal("status_set","is_roll",false)
		emit_signal("status_set","is_invincible",false)
		is_roll = false
		is_invincible = false
#
func adavio_melee() -> void:
	#form_melee_input()
	if is_melee == true:
		melee.enable()
		melee.parent_velocity = player.velocity
		animations.play("anim_adavio_hook_" + last_dir)
		await animations.animation_finished
		#print_debug("Adavio Melee Test")
		melee.disable()
		emit_signal("status_set","is_attack",false)
		emit_signal("status_set","is_melee",false)
		is_attack = false
		is_melee = false
#
func adavio_magic() -> void:
	#form_magic_input()
	if is_magic == true:
		magic.is_magic = true
		magic.visible = true
		var cdir = int(magic.get_rotation_degrees()) #magic.get_rotation_degrees()
		magic_dir = form_cursor_direction(cdir)
		last_dir = form_cursor_direction(cdir)
		magic.last_dir = last_dir
		if animations:
			if player_velocity.length() != 0:
				animations.play("anim_adavio_runCast_" + magic_dir)
			else:
				animations.play("anim_adavio_idleCast_" + last_dir)
	else:
		magic.is_magic = false
		magic.visible = false
	#
	#if is_magic == true:
		#magic.player = player
		#var cdir = int(magic.get_rotation_degrees()) #magic.get_rotation_degrees()
		#magic_dir = form_cursor_direction(cdir)
		#last_dir = form_cursor_direction(cdir)
		#if animations:
			#if player_velocity.length() != 0:
				#animations.play("anim_adavio_runCast_" + magic_dir)
			#else:
				#animations.play("anim_adavio_idleCast_" + last_dir)
#
func adavio_special() -> void:
	if t_special > 0:
		t_special = t_special - 1
	if is_special == true:
		#Check for line of sight with stage
		if special_start == false: 
			emit_signal("cursor_los_check",special)
			#Animate, then enter state if enough charge
			animations.play("anim_adavio_special_cast")
			await animations.animation_finished
			special.is_special = true
			
		
		if Input.is_action_just_pressed("magic_skill"): 
			#If not already using skill
			if special_use == false: 
				if cursor_los == false:
					player.violet_special = player.violet_special - 75
					player.special_gui.update()
					player.is_invincible = true
					special_use = true
					#is_invincible = true
					animations.play("anim_adavio_special_exit")
					if autoload_game.audio_mute == false:
						special.special_snd.play()
					await animations.animation_finished
					player.global_position = player.get_global_mouse_position()
					special.special_use = true
					special.t1 = 24
					special.t2 = 42
					animations.play("anim_adavio_special_enter")
					await animations.animation_finished
					player.is_attack = false
					player.is_special = false
					player.is_invincible = false
					is_attack = false
					is_special = false
					special_start = false
					special_use = false
					special.is_special = false
					special.special_use = false
					special.special_collision.disable()
#
func adavio_base() -> void:
	#CM: _physics_process
	if is_melee == true: return
	if is_roll == true: return
	#
	if is_attack == false:
		if player_velocity.length() != 0:
			form_move_audio(18)
			direction = "down"
			last_dir = "down"
			if player_velocity.x < 0: 
				direction = "left"
				last_dir = "left"
			elif player_velocity.x > 0: 
				direction = "right"
				last_dir = "right"
			elif player_velocity.y < 0: 
				direction = "up"
				last_dir = "up"
			animations.play("anim_adavio_run_" + direction)
		else:
			animations.play("anim_adavio_idle_" + last_dir)
#
#func play_move_audio(_stepSpeed):
	#if _tMove >= 0:
		#_tMove = _tMove - 1
	#if _tMove < 0:
		#_tMove = _stepSpeed
		#if autoload_game.audio_mute == false:
			#move_audio.play()
#

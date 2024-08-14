#Enemy Skirmisher
#
extends Enemy
#
#Built-In Methods
#
func _ready() -> void:
	skirmisher_ready()
	call_deferred("enemy_nav_setup")
	melee.is_melee = false
#
func _physics_process(delta) -> void:
	skirmisher_melee_state()
	skirmisher_hurt_state()
	skirmisher_navigation()
	skirmisher_animation()
#
#Custom Methods
#
func skirmisher_ready() -> void:
	sprite = $EnemySprite
	animations = $AnimationPlayer
	effects = $Effects
	health = $HealthBar
	hurt_timer = $HurtTimer
	hurt_box = $HitArea/Hitbox
	melee = $MeleeWeapon
	melee_box = $MeleeWeapon/Damagebox
	melee_timer = $MeleeWeapon/MeleeTimer
	melee_detect = $Navigation/MeleeDetect/MeleeDetectCircle
	nav_agent = $Navigation/NavigationAgent2D
	hurt_audio = $HurtSFX
#
func skirmisher_melee_state() -> void:
	if t_melee > 0:
		t_melee = t_melee - 1
	if is_melee == true:
		velocity.x = 0
		velocity.y = 0
		if t_melee <= 0:
			t_melee = 90
			melee.melee_aud_timer.start()
			animations.play("anim_skirmisher_slash_" + last_dir)
			await animations.animation_finished
			animations.play("anim_skirmisher_idle_" + last_dir)
			if melee_targets.size() < 1:
				melee.is_melee = false
				is_attack = false
				is_melee = false
#
func skirmisher_hurt_state() -> void:
	if is_hurt == true:
		if hurt_areas.size() > 0:
			for i in hurt_areas.size():
				var _damageArea = hurt_areas[i]
				if autoload_enemy.hitbox_area_entered(_damageArea,blood_particle,global_position):
					enemy_apply_damage(_damageArea)
			if hurt_timer.get_time_left() <= 0:
				var _cryChance = randi_range(0,100)
				if _cryChance >= 50:
					if autoload_game.audio_mute == false:
						hurt_audio.play()
				if autoload_game.audio_mute == false:
					autoload_player.player.damage_dealt_audio.play()
				hurt_timer.start()
#
func skirmisher_navigation() -> void:
	move_and_slide()
	enemy_aggro_drop()
	#
	if is_knockback == true:
		t_knockback = t_knockback - 1
		if t_knockback < 1:
			velocity.x = 0
			velocity.y = 0
			is_knockback = false
		return
	if is_melee == true: return
	if nav_agent.is_navigation_finished():
		if is_aggro == true:
			velocity.x = 0
			velocity.y = 0
			return
		else:
			for spawn in get_tree().get_nodes_in_group("EnemyPathPoint"):
				if spawn.name == str(objective_num + 1):
					nav_agent.target_position  = spawn.global_position
			objective_num = objective_num + 1
		
	var agent_current_pos = global_position
	var next_path_position = nav_agent.get_next_path_position()
	velocity = agent_current_pos.direction_to(next_path_position) * speed
#
func skirmisher_animation() -> void:
	if is_melee == true: return
	if is_knockback == true: return
		
	if velocity.length() != 0:
		move_dir = velocity.normalized()
		direction = "down"
		last_dir = "down"
		if round(move_dir.x) < 0: 
			direction = "left"
			last_dir = "left"
		if round(move_dir.x) > 0: 
			direction = "right"
			last_dir = "right"
		if round(move_dir.y) < 0: 
			direction = "up"
			last_dir = "up"
		if round(move_dir.y) > 0: 
			direction = "down"
			last_dir = "down"
		
		animations.play("anim_skirmisher_run_" + direction)
	else:
		animations.play("anim_skirmisher_idle_" + last_dir)
#
#Signal Methods
#
func _on_melee_detect_area_entered(area) -> void:
	if melee_targets.find(area) == -1:
		melee_targets.append(area)
	if is_attack == false:
		is_attack = true
		is_melee = true
		melee.is_melee = true
#
func _on_melee_detect_area_exited(area) -> void:
	var _targetInd = melee_targets.find(area)
	if _targetInd != -1:
		melee_targets.pop_at(_targetInd)
#
func _on_recalculate_timer_timeout() -> void:
	if target_node:
		nav_agent.target_position = target_node.global_position
#
func _on_aggro_detect_area_entered(area) -> void:
	is_aggro = true
	t_aggro = 300
	target_node = area.owner
#
func _on_aggro_drop_area_exited(area) -> void:
	is_aggro = false
#
func _on_hitbox_area_entered(area) -> void:
	if area == $MeleeWeapon: return
	if area == $HitArea: return
	is_hurt = true
	sprite.apply_intensity_fade(1.0,0.0,0.25)
	sprite._set("is_hurt",true)
	if hurt_areas.find(area) == -1:
		hurt_areas.append(area)
#
func _on_hitbox_area_exited(area) -> void:
	var _targetInd = hurt_areas.find(area)
	if _targetInd != -1:
		hurt_areas.pop_at(_targetInd)
	if hurt_areas.size() <= 0:
		is_hurt = false
#
func _on_melee_audio_timer_timeout() -> void:
	if autoload_game.audio_mute == false:
		melee.melee_audio.play()







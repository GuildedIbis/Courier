#scr_rm_farway
#
extends Node2D
#
@export var player_scene: PackedScene
#
@onready var tilemap: TileMapLayer = $TileMap/Base
@onready var game_hud: CanvasLayer = $GameHUD
@onready var enemy_prog: TextureProgressBar = $GameHUD/EnemyProgress
@onready var wave_label: Label = $GameHUD/EnemyProgress/WaveLabel
@onready var enemy_label: Label = $GameHUD/EnemyProgress/EnemyLabel
@onready var victory_label: Label = $GameHUD/VictoryLabel
@onready var current_enemy0: CharacterBody2D 
@onready var current_enemy1: CharacterBody2D
@onready var current_enemy2: CharacterBody2D
@onready var current_enemy3: CharacterBody2D
@onready var current_enemy4: CharacterBody2D
@onready var current_enemy5: CharacterBody2D
@onready var enemy0: PackedScene # = preload("res://Scenes/EnemyEntities/ent_skirmisher.tscn")
@onready var enemy1: PackedScene # = preload("res://Scenes/EnemyEntities/ent_hunter.tscn")
@onready var enemy2: PackedScene # = preload("res://Scenes/EnemyEntities/ent_gorog.tscn")

#
var fps: int = autoload_game.fps_target 
var max_squads: int
var squad_size: int
var rem_squads: int
var squad_comp: Array
var enemy_spawn_timer: float = 0.0
var max_prewave: float = 180.0
var prewave: float = 180.0
var wave_started: bool = false
var form_menu: bool = false
var round_complete: bool = false
var t_victory: float = 300.0
#Spawner Variables
var group_array: Array
var group_num: int = 0
var group_rand: int
var spawn_dist: float
var spawn0: String = "00"
var spawn1: String = "01"
var spawn2: String = "02"
var spawn3: String = "03"
var spawn4: String = "04"
var spawn5: String = "05"
#
#
#Built-In Functions
#
func _ready() -> void:
	print_debug("Mode:" + str(autoload_game.mode))
	autoload_game.room = self
	if autoload_game.mode == 1:
		autoload_enemy.build_enemy_list()
		#farway_spawn_comp_update()
		var current_player = player_scene.instantiate()
		add_child(current_player)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(0):
				current_player.global_position = spawn.global_position
				current_player.tilemap = tilemap
				current_player.player_update_cam_tilemap()
				current_player.room_space = self
		autoload_player.player = current_player
		pass
		
	if autoload_game.mode == 2:
		var current_player = player_scene.instantiate()
		add_child(current_player)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(0):
				current_player.global_position = spawn.global_position
				current_player.tilemap = tilemap
				current_player.room_space = self
		pass 
#
func _physics_process(delta) -> void:
	if round_complete == true:
		victory_label.visible = true
		t_victory = t_victory - (delta * fps)
		if t_victory <= 0:
			autoload_game.mode = 0
			get_tree().change_scene_to_file("res://Scenes/RoomScenes/MetaRooms/rm_home.tscn")
		return
	if wave_started == false:
		if prewave > 0:
			prewave = prewave - (delta * fps)
			enemy_prog.update_prewave_progress((prewave) * 100/max_prewave)
		if prewave <= 0:
			prewave = max_prewave
			wave_started = true
			squad_comp.clear()
			farway_spawn_setup()
	if wave_started == true:
		farway_enemy_spawner(delta)
	
#
#Custom Functions
#
func wave_restart() -> void:
	wave_started = false
	prewave = 180
	rem_squads = max_squads
#
func farway_enemy_spawner(delta) -> void:
	#CM: _physics_process
	#Spawn Squads of Enemies or Start Prewave Countdown
	if rem_squads > 0:
		if enemy_spawn_timer > 0:
			enemy_spawn_timer = enemy_spawn_timer - (delta * fps)
		if enemy_spawn_timer <= 0:
			rem_squads = rem_squads - 1
			#print_debug(rem_squads)
			farway_spawn_comp_update()
			enemy_spawn_timer = 300
			enemy_prog.update_enemy_progress((rem_squads) * 100/max_squads)
			farway_spawn_group_select()
			for i in range(0,squad_comp.size()):
				room_instantiate_enemy(i)
			update_labels()
			if rem_squads <= 0:
				for _en in get_tree().get_nodes_in_group("Enemy"):
					_en.enemy_marker.visible = true
	#
	if rem_squads <= 0 && autoload_game.enemy_count <= 0:
		if autoload_game.local_wave <= 4:
			autoload_player.player.player_restore_all()
			autoload_game.local_wave = autoload_game.local_wave + 1
			autoload_game.game_wave = autoload_game.game_wave + 1
			wave_started = false
			prewave = max_prewave
			enemy_spawn_timer = 0
			update_labels()
		else:
			round_complete = true
			autoload_player.player.player_restore_all()
			autoload_game.local_wave = 1
			autoload_game.game_wave = 1
			wave_started = false
			prewave = max_prewave
			enemy_spawn_timer = 0
			update_labels()
#
func farway_spawn_group_select() -> void:
	#CM: farway_enemy_spawner
	#Spawner Group Selection
	#Randomly selects a group node, so long as player is not in range
	for group in get_tree().get_nodes_in_group("EnemySpawnGroup"):
		if group.collision_list.size() <= 0:
			match group.name:
				"SpawnGroupA":
					group_array.append(0)
				"SpawnGroupB":
					group_array.append(1)
				"SpawnGroupC":
					group_array.append(2)
	group_rand = randi_range(0,group_array.size()-1)
	group_num = group_array[group_rand]
#
func farway_spawn_setup() -> void:
	#CM: _physics_process: called once at start of wave/end of prewave
	#Set wave length in squads and set intial squad composition
	match autoload_game.local_wave:
		1:
			max_squads = 6
			rem_squads = max_squads
			farway_spawn_comp_update()
		2:
			max_squads = 7
			rem_squads = max_squads
			farway_spawn_comp_update()
		3:
			max_squads = 8
			rem_squads = max_squads
			farway_spawn_comp_update()
		4:
			max_squads = 9
			rem_squads = max_squads
			farway_spawn_comp_update()
		5:
			max_squads = 10
			rem_squads = max_squads
			farway_spawn_comp_update()
#
func farway_spawn_comp_update():
	#CM: farway_spawn_setup, farway_enemy_spawner
	#Set the enemy squad composition
	#print_debug(max_squads - rem_squads)
	match autoload_game.local_wave:
		1:
			match max_squads - rem_squads:
				1: #2
					squad_comp.clear()
					for i in [0]:
						squad_comp.append(i)
				3: #6
					squad_comp.clear()
					for i in [0,0]:
						squad_comp.append(i)
				5: #12
					squad_comp.clear()
					for i in [0,0,0]:
						squad_comp.append(i)
		2:
			match max_squads - rem_squads:
				1:
					squad_comp.clear()
					for i in [1]:
						squad_comp.append(i)
				3:
					squad_comp.clear()
					for i in [1,0]:
						squad_comp.append(i)
				4:
					squad_comp.clear()
					for i in [1,0,0]:
						squad_comp.append(i)
		3:
			match max_squads - rem_squads:
				1:
					squad_comp.clear()
					for i in [0,1]:
						squad_comp.append(i)
					
				3:
					squad_comp.clear()
					for i in [0,1,2]:
						squad_comp.append(i)
				5:
					squad_comp.clear()
					for i in [0,1,1]:
						squad_comp.append(i)
				7:
					squad_comp.clear()
					for i in [0,1,2]:
						squad_comp.append(i)
		4:
			match max_squads - rem_squads:
				1:
					squad_comp.clear()
					for i in [2,1]:
						squad_comp.append(i)
				3:
					squad_comp.clear()
					for i in [0,1,2]:
						squad_comp.append(i)
				5:
					squad_comp.clear()
					for i in [0,0,0,1]:
						squad_comp.append(i)
				7:
					squad_comp.clear()
					for i in [0,1,1]:
						squad_comp.append(i)
		5:
			match max_squads - rem_squads:
				1:
					squad_comp.clear()
					for i in [0,1,1]:
						squad_comp.append(i)
				3:
					squad_comp.clear()
					for i in [0,1,1,2]:
						squad_comp.append(i)
				5:
					squad_comp.clear()
					for i in [0,1,1,1]:
						squad_comp.append(i)
				7:
					squad_comp.clear()
					for i in [0,0,0,1,2]:
						squad_comp.append(i)
				9:
					squad_comp.clear()
					for i in [0,0,1,1,2]:
						squad_comp.append(i)
#
func room_instantiate_enemy(_spawnNum) -> void:
	#CM: farway_enemy_spawner: called in a for loop of squad_comp.size()
	#Set Random Enemy from 
	var load_enemy
	match _spawnNum:
		0:
			load_enemy = autoload_enemy.enemy_list[squad_comp[_spawnNum]]
			current_enemy0 = load_enemy.instantiate()
			#current_enemy0 = room_set_enemy_id(squad_comp[_spawnNum]).instantiate()
			add_child(current_enemy0)
			spawn0 = str(group_num,0)
			room_enemy_spawn_position(spawn0,current_enemy0)
		1:
			load_enemy = autoload_enemy.enemy_list[squad_comp[_spawnNum]]
			current_enemy1 = load_enemy.instantiate()
			#current_enemy1 = room_set_enemy_id(squad_comp[_spawnNum]).instantiate()
			add_child(current_enemy1)
			spawn1 = str(group_num,1)
			room_enemy_spawn_position(spawn1,current_enemy1)
		2:
			load_enemy = autoload_enemy.enemy_list[squad_comp[_spawnNum]]
			current_enemy2 = load_enemy.instantiate()
			#current_enemy2 = room_set_enemy_id(squad_comp[_spawnNum]).instantiate()
			add_child(current_enemy2)
			spawn2 = str(group_num,2)
			room_enemy_spawn_position(spawn2,current_enemy2)
		3:
			load_enemy = autoload_enemy.enemy_list[squad_comp[_spawnNum]]
			current_enemy3 = load_enemy.instantiate()
			#current_enemy3 = room_set_enemy_id(squad_comp[_spawnNum]).instantiate()
			add_child(current_enemy3)
			spawn3 = str(group_num,3)
			room_enemy_spawn_position(spawn3,current_enemy3)
		4: 
			load_enemy = autoload_enemy.enemy_list[squad_comp[_spawnNum]]
			current_enemy4 = load_enemy.instantiate()
			#current_enemy4 = room_set_enemy_id(squad_comp[_spawnNum]).instantiate()
			add_child(current_enemy4)
			spawn4 = str(group_num,4)
			room_enemy_spawn_position(spawn4,current_enemy4)
		5:
			load_enemy = autoload_enemy.enemy_list[squad_comp[_spawnNum]]
			current_enemy5 = load_enemy.instantiate()
			#current_enemy5 = room_set_enemy_id(squad_comp[_spawnNum]).instantiate()
			add_child(current_enemy5)
			spawn5 = str(group_num,5)
			room_enemy_spawn_position(spawn5,current_enemy5)
	autoload_game.enemy_count = get_tree().get_node_count_in_group("Enemy")
	#print_debug(autoload_game.enemy_count)
#
func room_enemy_spawn_position(_spawnName,_spawnEnemy) -> void:
	#Spawn Enemies
	for spawn in get_tree().get_nodes_in_group("EnemySpawnPoint"):
		if spawn.name == _spawnName:
			_spawnEnemy.global_position = spawn.global_position
#
func update_labels() -> void:
	wave_label.text = str(autoload_game.local_wave)
	if autoload_game.enemy_count > 0:
		enemy_label.text = str(autoload_game.enemy_count)
	else:
		enemy_label.text = str("")
#
func _on_inventory_gui_closed() -> void:
	get_tree().paused = false
#
func _on_inventory_gui_opened() -> void:
	get_tree().paused = true

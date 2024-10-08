#Player Special Bar
#
extends TextureProgressBar
#
@onready var player = $"../.."
@onready var yellow_texture = preload("res://Sprites/GUISprites/PlayerGUI/RadialFills/spr_gui_healthbar_radial_fill_yellow.png")
@onready var violet_texture = preload("res://Sprites/GUISprites/PlayerGUI/RadialFills/spr_gui_healthbar_radial_fill_violet.png")
@onready var sprite: AnimatedSprite2D = $SpecialBarSprite 
#
var player_num: int = 0
#
#Built-in Methods
#
func _ready() -> void:
	update()
#
#Custom Methods
#
func update() -> void:
	#CM: Form Controller > Special Skill > _physics_process
	player_num = player.form_id
	sprite.frame = player_num
	match player.form_type:
		0:
			set_progress_texture(yellow_texture)
			value = player.yellow_special * 100 / player.current_max
		1:
			set_progress_texture(violet_texture)
			value = player.violet_special * 100 / player.current_max

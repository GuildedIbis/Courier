#Player Primary Bar
#
extends TextureProgressBar
#
@onready var player = $"../.."
@onready var yellow_texture = preload("res://Sprites/GUISprites/PlayerGUI/RadialFills/spr_gui_healthbar_radial_fill_yellow.png")
@onready var violet_texture = preload("res://Sprites/GUISprites/PlayerGUI/RadialFills/spr_gui_healthbar_radial_fill_violet.png")
@onready var sprite: AnimatedSprite2D = $PrimaryBarSprite
#
var player_num: int = 0
#
#Built-in Methods
#
func _ready():
	update()
#
#Custom Methods
#
func update() -> void:
	#CM: Form Controller > Magic Skill > _physics process
	player_num = player.form_id
	sprite.frame = player_num
	
	if player.yellow_primary > player.current_max:
		player.yellow_primary = player.current_max
	if player.violet_primary > player.current_max:
		player.violet_primary = player.current_max
	match player.form_type:
		0:
			set_progress_texture(yellow_texture)
			value = player.yellow_primary * 100 / player.current_max
		1:
			set_progress_texture(violet_texture)
			value = player.violet_primary * 100 / player.current_max

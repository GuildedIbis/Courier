#Enemy Health Bar
#
extends TextureProgressBar
#
@onready var enemy = get_parent()
#
#Built-In Methods
#
func _ready():
	value = 100
	#call_deferred("update")
#
#Custom Methods
#
#func update():
	#value = enemy.hp * 100 / enemy.max_hp

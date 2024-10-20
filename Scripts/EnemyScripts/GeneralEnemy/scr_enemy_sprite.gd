#scr_enemy_sprite
#
extends Sprite2D
#
@export var is_hurt: bool = false
@export var is_shielded: bool = false
#
#Built-In Functions
#
func _set(property: StringName, value: Variant) -> bool:
	match property:
		"is_hurt":
			if value == false:
				material.set_shader_parameter("is_hurt",false)
			else:
				material.set_shader_parameter("is_hurt",true)
				material.set_shader_parameter("is_shielded",false)
		"is_shielded":
			if value == false:
				material.set_shader_parameter("is_shielded",false)
			else:
				material.set_shader_parameter("is_shielded",true)
	return false
#
#Custom Functions
#
func apply_intensity_fade(_start,_finish,_length) -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_blinkIntensity,_start,_finish,_length)
#
func set_shader_blinkIntensity(_newValue: float) -> void:
	material.set_shader_parameter("blink_intensity", _newValue)

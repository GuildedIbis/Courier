#
#
extends Area2D
#
#@onready var player: CharacterBody2D
#
var damage: int
var inflict_kb: bool = false
var is_magic: bool = true
var is_kinetic: bool = false
var enemy_hit: Array
var type: int = 0


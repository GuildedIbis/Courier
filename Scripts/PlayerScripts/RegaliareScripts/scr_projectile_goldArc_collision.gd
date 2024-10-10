extends Area2D

@onready var player: CharacterBody2D

var damage: int
var inflict_kb: bool = false
var is_magic: bool = true
var is_kinetic: bool = false
var kb_power: int = 250
var enemy_hit: Array
var t1: int = 0
var type: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if t1 >= 0:
		t1 = t1 - (delta * 60)
		
	if t1 <= 0:
		enemy_hit.clear()
		t1 = 15

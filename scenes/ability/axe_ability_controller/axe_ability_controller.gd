extends Node

const MAX_RANGE = 120

@export var axe_ability: PackedScene

@onready var prepare_attack: Timer = $PrepareAttack
@onready var cooldown: Timer = $Cooldown

var base_attack_speed = 0.33
var current_attack_speed = base_attack_speed
var damage: float = 10


func _ready() -> void:
	prepare_attack.timeout.connect(on_prepare_attack_timeout)
	cooldown.wait_time = 1/current_attack_speed


func on_prepare_attack_timeout():
	if !cooldown.is_stopped():
		return
		
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground_layer == null:
		return
		
	var axe_instance = axe_ability.instantiate() as Node2D
	foreground_layer.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = damage
	$Cooldown.start()

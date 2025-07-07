extends Node

const MAX_RANGE = 120

@export var axe_ability: PackedScene

@onready var prepare_attack: Timer = $PrepareAttack

var base_attack_speed = 0.33
var current_attack_speed = base_attack_speed
var base_damage: float = 10
var additional_damage_percent = 1
var axe_count = 0
var upgrade_scale = Vector2.ZERO
var base_scale = Vector2.ONE


func _ready() -> void:
	prepare_attack.timeout.connect(on_prepare_attack_timeout)
	prepare_attack.wait_time = 1/current_attack_speed
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)


func on_prepare_attack_timeout():
		
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground_layer == null:
		return
	
	var total_axes = axe_count + 1
	for i in total_axes:
		var axe_instance = axe_ability.instantiate() as Node2D
		foreground_layer.add_child(axe_instance)
		axe_instance.global_position = player.global_position
		axe_ability.scale = base_scale + upgrade_scale
		axe_instance.additional_rotation = i * (TAU / total_axes)
		axe_instance.hitbox_component.damage = base_damage * additional_damage_percent



func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "axe_count":
		axe_count = current_upgrades["axe_count"]["quantity"]
		
	elif  upgrade.id == "axe_rate":
		var percent_reduction = current_upgrades["axe_rate"]["quantity"] * 0.1
		current_attack_speed += base_attack_speed * percent_reduction
		prepare_attack.wait_time = 1/current_attack_speed
		
	elif upgrade.id == "axe_damage":
		var damage_quantity = current_upgrades["arrow_damage"]["quantity"]
		additional_damage_percent = 1 + (damage_quantity * 0.2)
		upgrade_scale = Vector2(damage_quantity * 0.1, damage_quantity * 0.1)

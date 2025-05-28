extends Node

const MAX_RANGE = 120

@export var axe_ability: PackedScene

@onready var prepare_attack: Timer = $PrepareAttack
@onready var cooldown: Timer = $Cooldown

var base_attack_speed = 0.33
var current_attack_speed = base_attack_speed
var base_damage: float = 10
var additional_damage_percent = 1


func _ready() -> void:
	prepare_attack.timeout.connect(on_prepare_attack_timeout)
	cooldown.wait_time = 1/current_attack_speed
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)


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
	axe_instance.hitbox_component.damage = base_damage * additional_damage_percent
	$Cooldown.start()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "axe_rate":
		var percent_reduction = current_upgrades["axe_rate"]["quantity"] * 0.1
		current_attack_speed += base_attack_speed * percent_reduction
		$Cooldown.wait_time = 1/current_attack_speed
		$Cooldown.start()
	elif upgrade.id == "axe_damage":
		additional_damage_percent = 1 + (current_upgrades["axe_damage"]["quantity"] * 0.15)

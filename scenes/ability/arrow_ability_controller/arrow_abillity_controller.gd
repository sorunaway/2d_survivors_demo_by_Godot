extends Node

@export var arrow_ability_scene:PackedScene

var base_attack_speed = 0.7
var current_attack_speed = base_attack_speed
var base_damage: float = 3.0
var additional_damage_percent = 1
var arrow_count = 0


func _ready() -> void:
	$PrepareAttack.timeout.connect(on_prepare_attack_timeout)
	$PrepareAttack.wait_time = 1/current_attack_speed
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)


func on_prepare_attack_timeout():
	# 获取player节点
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	for i in arrow_count + 1:
		var arrow_ability = arrow_ability_scene.instantiate()
		get_tree().get_first_node_in_group("foreground_layer").add_child(arrow_ability)
		arrow_ability.global_position = player.global_position
		arrow_ability.hitbox_component.damage = base_damage * additional_damage_percent
		await get_tree().create_timer(0.15).timeout


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "arrow_count":
		arrow_count = current_upgrades["arrow_count"]["quantity"]
	# 攻速增加10%
	elif upgrade.id == "arrow_rate":
		var percent_reduction = current_upgrades["arrow_rate"]["quantity"] * 0.1
		
		current_attack_speed += base_attack_speed * percent_reduction
		$PrepareAttack.wait_time = 1/current_attack_speed
		$PrepareAttack.start()

	# 伤害增加30%
	elif upgrade.id == "arrow_damage":
		additional_damage_percent = 1 + (current_upgrades["arrow_damage"]["quantity"] * 0.3)

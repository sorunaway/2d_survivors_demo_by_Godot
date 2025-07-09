extends Node

@export var arrow_ability_scene:PackedScene

var base_attack_speed = 0.6
var current_attack_speed = base_attack_speed
var base_damage: float = 4.0
var additional_damage_percent = 1
var arrow_count = 0
var damage_upgrade = 0.0
var range_upgrade = 0.0
var upgrade_scale = Vector2.ZERO
var base_scale = Vector2.ONE


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
		
		#arrow_ability.max_percent = 1.0 + damage_upgrade
		arrow_ability.damage_upgrade_range = range_upgrade
		arrow_ability.scale = base_scale + upgrade_scale
		arrow_ability.hitbox_component.damage = base_damage * additional_damage_percent
		await get_tree().create_timer(0.1).timeout


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "arrow_count":
		arrow_count = current_upgrades["arrow_count"]["quantity"]
	# 攻速增加10%
	elif upgrade.id == "arrow_rate":
		var percent_reduction = current_upgrades["arrow_rate"]["quantity"] * 0.1
		
		current_attack_speed = base_attack_speed * (1 + percent_reduction)
		$PrepareAttack.wait_time = 1/current_attack_speed
		$PrepareAttack.start()

	# 伤害增加30%
	elif upgrade.id == "arrow_damage":
		var damage_quantity = current_upgrades["arrow_damage"]["quantity"]
		additional_damage_percent = 1 + (damage_quantity * 0.3)
		range_upgrade = damage_quantity * 30
		upgrade_scale = Vector2(damage_quantity * 0.1, damage_quantity * 0.1)

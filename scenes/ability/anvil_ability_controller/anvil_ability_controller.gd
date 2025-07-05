extends Node

const MAX_RANGE = 150

@export var anvil_ability_scene: PackedScene

var base_attack_speed = 0.3
var current_attack_speed = base_attack_speed
var base_damage: float = 20.0
var additional_damage_percent = 1
var anvil_count = 0
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
	
	for i in anvil_count + 1:
		var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
		var spawn_position = player.global_position + (direction * randf_range(32, MAX_RANGE))
		# 射线检测防止落在场景外
		var query_paramaters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_paramaters)
		if !result.is_empty():
			spawn_position = result["position"]
		
		var anvil_ability = anvil_ability_scene.instantiate() as Node2D
		get_tree().get_first_node_in_group("foreground_layer").add_child(anvil_ability)
		anvil_ability.global_position = spawn_position
		anvil_ability.scale = base_scale + upgrade_scale
		anvil_ability.hitbox_component.damage = base_damage * additional_damage_percent
		await get_tree().create_timer(0.2).timeout


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "anvil_count":
		anvil_count = current_upgrades["anvil_count"]["quantity"]
	# 攻速增加10%
	elif upgrade.id == "anvil_rate":
		var percent_reduction = current_upgrades["anvil_rate"]["quantity"] * 0.1
		
		current_attack_speed += base_attack_speed * percent_reduction
		$PrepareAttack.wait_time = 1/current_attack_speed
		$PrepareAttack.start()

	# 伤害增加20%
	elif upgrade.id == "anvil_damage":
		var damage_quantity = current_upgrades["anvil_damage"]["quantity"]
		additional_damage_percent = 1 + (damage_quantity * 0.2)
		upgrade_scale = Vector2(damage_quantity * 0.2, damage_quantity * 0.2)

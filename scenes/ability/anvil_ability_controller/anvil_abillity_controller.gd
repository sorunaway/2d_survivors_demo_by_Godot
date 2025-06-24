extends Node

const MAX_RANGE = 150

@export var anvil_ability_scene:PackedScene

var base_attack_speed = 0.5
var current_attack_speed = base_attack_speed
var base_damage: float = 20.0
var additional_damage_percent = 1
var anvil_count = 1


func _ready() -> void:
	$PrepareAttack.timeout.connect(on_prepare_attack_timeout)
	#$Cooldown.wait_time = 1/current_attack_speed
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)


func on_prepare_attack_timeout():
	# 获取player节点
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var additional_rotation_degrees = 360.0 / (anvil_count + 1)
	var anvil_distance = randf_range(0, MAX_RANGE)
	for i in anvil_count + 1:
		var adjusted_direction = direction.rotated(deg_to_rad(i * additional_rotation_degrees))
		var spawn_position = player.global_position + (adjusted_direction * anvil_distance)
		
		var query_paramaters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_paramaters)
		if !result.is_empty():
			spawn_position = result["position"]
		
		var anvil_ability = anvil_ability_scene.instantiate()
		get_tree().get_first_node_in_group("foreground_layer").add_child(anvil_ability)
		anvil_ability.global_position = spawn_position
		anvil_ability.hitbox_component.damage = base_damage


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "anvil_count":
		anvil_count = current_upgrades["anvil_count"]["quantity"]
	# 攻速增加10%
	if upgrade.id == "anvil_rate":
		var percent_reduction = current_upgrades["anvil_rate"]["quantity"] * 0.1
		current_attack_speed += base_attack_speed * percent_reduction
		$Cooldown.wait_time = 1/current_attack_speed
		$Cooldown.start()
	# 伤害增加30%
	elif upgrade.id == "anvil_damage":
		additional_damage_percent = 1 + (current_upgrades["anvil_damage"]["quantity"] * 0.3)

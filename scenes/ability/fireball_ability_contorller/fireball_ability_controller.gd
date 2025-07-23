extends Node

const MAX_RANGE = 240
#const BASE_ANGLE_OFFSET = 12 #每个火球的基础角度偏移

@export var fireball_ability_scene: PackedScene

var base_attack_speed = 0.28
var current_attack_speed = base_attack_speed
var base_damage: float = 16.0
var additional_damage_percent = 1
var fireball_count = 0
var upgrade_scale = Vector2.ZERO
var base_scale = Vector2.ONE
var random_enemy_position = Vector2.UP
var additional_fireball_speed = 0 # 弹道速度升级加成


func _ready() -> void:
	$PrepareAttack.timeout.connect(on_prepare_attack_timeout)
	$PrepareAttack.wait_time = 1/current_attack_speed
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)


func on_prepare_attack_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	for i in fireball_count + 1:
		var base_target = pick_random_enemy_position()
		
		var fireball_ability = fireball_ability_scene.instantiate() as Node2D
		fireball_ability.global_position = player.global_position
		fireball_ability.target = base_target
		
		fireball_ability.scale = base_scale + upgrade_scale
		fireball_ability.speed = 120 + additional_fireball_speed
		
		get_tree().get_first_node_in_group("foreground_layer").add_child(fireball_ability)
		fireball_ability.hitbox_component.damage = base_damage * additional_damage_percent
		
		await get_tree().create_timer(0.06).timeout


func pick_random_enemy_position():
	# 获取player节点
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	# 获取敌人节点
	var enemies = get_tree().get_nodes_in_group("enemy")
		# 过滤，只留在范围内的敌人
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
		)
	if enemies.size() == 0:
		var random_angle = randf_range(0, TAU)
		return player.global_position + Vector2(cos(random_angle), sin(random_angle)) * MAX_RANGE
		
	else :
		return enemies.pick_random().global_position


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "fireball_count":
		fireball_count = current_upgrades["fireball_count"]["quantity"]
		
	# 攻速增加10%
	elif upgrade.id == "fireball_rate":
		var percent_reduction = current_upgrades["fireball_rate"]["quantity"] * 0.1
		additional_fireball_speed = percent_reduction * 300
		current_attack_speed = base_attack_speed * (1 + percent_reduction)
		$PrepareAttack.wait_time = 1/current_attack_speed
		$PrepareAttack.start()

	# 伤害增加20%
	elif upgrade.id == "fireball_damage":
		var damage_quantity = current_upgrades["fireball_damage"]["quantity"]
		additional_damage_percent = 1 + (damage_quantity * 0.2)
		upgrade_scale = Vector2(damage_quantity * 0.15, damage_quantity * 0.15)

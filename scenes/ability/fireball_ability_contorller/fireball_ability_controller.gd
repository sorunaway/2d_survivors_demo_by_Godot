extends Node

const MAX_RANGE = 240
const BASE_ANGLE_OFFSET = 12 #每个火球的基础角度偏移

@export var fireball_ability_scene: PackedScene

var base_attack_speed = 0.4
var current_attack_speed = base_attack_speed
var base_damage: float = 16.0
var additional_damage_percent = 1
var fireball_count = 0
var upgrade_scale = Vector2.ZERO
var base_scale = Vector2.ONE
var random_enemy_position = Vector2.UP
#var additional_fireball_hp = 0 # 穿透力升级加成
var additional_fireball_speed = 0 # 弹道速度升级加成


func _ready() -> void:
	$PrepareAttack.timeout.connect(on_prepare_attack_timeout)
	$PrepareAttack.wait_time = 1/current_attack_speed
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)


func on_prepare_attack_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	# 获取敌人位置作为基础方向
	var base_target = pick_random_enemy_position()
	# 计算总飞镖数量
	var total_fireballs = fireball_count + 1
	# 计算角度偏移量
	var angle_offset = deg_to_rad(BASE_ANGLE_OFFSET)
	# 计算中心飞镖索引（用于对称分布）
	var center_index = (total_fireballs - 1) / 2.0
	
	
	for i in fireball_count + 1:
		var fireball_ability = fireball_ability_scene.instantiate() as Node2D
		fireball_ability.global_position = player.global_position
		
		var current_angle_offset = (i - center_index) * angle_offset
		if total_fireballs == 1:
			fireball_ability.target = base_target
		else:
			var direction = player.global_position.direction_to(base_target)
			var rotated_direction = direction.rotated(current_angle_offset)
			fireball_ability.target = player.global_position + rotated_direction * MAX_RANGE
		
		fireball_ability.scale = base_scale + upgrade_scale
		#fireball_ability.hp = 1 + additional_fireball_hp
		fireball_ability.speed = 120 + additional_fireball_speed
		
		get_tree().get_first_node_in_group("foreground_layer").add_child(fireball_ability)
		fireball_ability.hitbox_component.damage = base_damage * additional_damage_percent


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
		fireball_count = current_upgrades["fireball_count"]["quantity"] * 2
		
	# 攻速增加10%
	elif upgrade.id == "fireball_rate":
		var percent_reduction = current_upgrades["fireball_rate"]["quantity"] * 0.1
		additional_fireball_speed = percent_reduction * 400
		current_attack_speed = base_attack_speed * (1 + percent_reduction)
		$PrepareAttack.wait_time = 1/current_attack_speed
		$PrepareAttack.start()

	# 伤害增加20%
	elif upgrade.id == "fireball_damage":
		var damage_quantity = current_upgrades["fireball_damage"]["quantity"]
		additional_damage_percent = 1 + (damage_quantity * 0.2)
		upgrade_scale = Vector2(damage_quantity * 0.15, damage_quantity * 0.15)
		#additional_fireball_hp = damage_quantity

extends Node

const MAX_RANGE = 240

@export var dart_ability_scene: PackedScene

var base_attack_speed = 0.7
var current_attack_speed = base_attack_speed
var base_damage: float = 5.0
var additional_damage_percent = 1
var dart_count = 0
var upgrade_scale = Vector2.ZERO
var base_scale = Vector2.ONE
var random_enemy_position = Vector2.UP


func _ready() -> void:
	$PrepareAttack.timeout.connect(on_prepare_attack_timeout)
	$PrepareAttack.wait_time = 1/current_attack_speed
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)


func on_prepare_attack_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	random_enemy_position = pick_random_enemy_position()
	for i in dart_count + 1:
		var dart_ability = dart_ability_scene.instantiate() as Node2D
		dart_ability.target = pick_random_enemy_position()
		dart_ability.global_position = player.global_position
		dart_ability.scale = base_scale + upgrade_scale
		get_tree().get_first_node_in_group("foreground_layer").add_child(dart_ability)
		dart_ability.hitbox_component.damage = base_damage * additional_damage_percent


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
		return Vector2.UP
		
	else :
		return enemies.pick_random().global_position
		




func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "dart_count":
		dart_count = current_upgrades["dart_count"]["quantity"]
	# 攻速增加10%
	elif upgrade.id == "dart_rate":
		var percent_reduction = current_upgrades["dart_rate"]["quantity"] * 0.1
		
		current_attack_speed += base_attack_speed * percent_reduction
		$PrepareAttack.wait_time = 1/current_attack_speed
		$PrepareAttack.start()

	# 伤害增加20%
	elif upgrade.id == "dart_damage":
		var damage_quantity = current_upgrades["dart_damage"]["quantity"]
		additional_damage_percent = 1 + (damage_quantity * 0.2)
		upgrade_scale = Vector2(damage_quantity * 0.2, damage_quantity * 0.2)

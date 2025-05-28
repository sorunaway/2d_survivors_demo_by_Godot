extends Node

const MAX_RANGE = 120

@export var sword_ability:PackedScene

var base_attack_speed = 0.5
var current_attack_speed = base_attack_speed
var base_damage: float = 5.0
var additional_damage_percent = 1


func _ready() -> void:
	$PrepareAttack.timeout.connect(on_prepare_attack_timeout)
	$Cooldown.wait_time = 1/current_attack_speed
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)


func on_prepare_attack_timeout():
	if !$Cooldown.is_stopped():
		return
	
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
		return
	
	else:
		# enemies组内排序
		enemies.sort_custom(func(a:Node2D, b:Node2D):
			var a_distance = a.global_position.distance_squared_to(player.global_position)
			var b_distance = b.global_position.distance_squared_to(player.global_position)
			return a_distance < b_distance
		)

		# 在敌人位置生成剑节点
		var sword_instance = sword_ability.instantiate() as SwordAbility
		var sword_direction = enemies[0].global_position - player.global_position
		var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
		foreground_layer.add_child(sword_instance)
		sword_instance.hitbox_component.damage = base_damage * additional_damage_percent
		# 位置偏移角度
		sword_instance.global_position = enemies[0].global_position - (sword_direction.normalized() * 12)
		sword_instance.rotation = sword_direction.angle()
		
		$Cooldown.start()
	


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "sword_rate":
		var percent_reduction = current_upgrades["sword_rate"]["quantity"] * 0.1
		current_attack_speed += base_attack_speed * percent_reduction
		$Cooldown.wait_time = 1/current_attack_speed
		$Cooldown.start()
	elif upgrade.id == "sword_damage":
		additional_damage_percent = 1 + (current_upgrades["sword_damage"]["quantity"] * 0.2)

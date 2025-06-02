extends Node

@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

var upgrade_axe = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_rate = preload("res://resources/upgrades/axe_rate.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")
var upgrade_player_speed = preload("res://resources/upgrades/player_speed.tres")


func _ready() -> void:
	upgrade_pool.add_item(upgrade_axe, 10)
	upgrade_pool.add_item(upgrade_sword_rate, 10)
	upgrade_pool.add_item(upgrade_sword_damage, 10)
	upgrade_pool.add_item(upgrade_player_speed, 5)
	
	experience_manager.level_up.connect(on_level_up)


# 应用升级
func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	# 判断是否已经获得同类型升级
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	# 如果有最大数量限制
	if upgrade.max_quantity > 0:
		# 如果当前能力的数量到达最大数量限制 从池中移除
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrades_added(upgrade, current_upgrades)


# 当选择了新能力，更新可拓展的升级能力池
func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == upgrade_axe.id:
		upgrade_pool.add_item(upgrade_axe_damage, 10)
		upgrade_pool.add_item(upgrade_axe_rate, 10)


func pick_upgrades():
	# 为已选择能力创建一个空数组
	var chosen_upgrades: Array[AbilityUpgrade] = []
	# 重复3次筛选待升级能力选项
	for i in 3:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades


#升级能力提升
func on_level_up(current_level: int):
	# 实例化创建升级UI窗口
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	# 传递随到的升级池到子节点的升级函数
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	# 接收子节点的升级选择信号
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


#收到选择信号后应用到升级
func on_upgrade_selected(upgrade:AbilityUpgrade):
	apply_upgrade(upgrade)

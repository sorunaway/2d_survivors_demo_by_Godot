extends Node


@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}


func _ready() -> void:
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
		# 如果当前能力的数量到达最大数量限制 从池中筛除掉ID相同的能力(即选择ID不同的能力)
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool = upgrade_pool.filter(func (pool_upgrade): return pool_upgrade.id != upgrade.id)
	
	GameEvents.emit_ability_upgrades_added(upgrade, current_upgrades)


func pick_upgrades():
	# 为已选择能力创建一个空数组
	var chosen_upgrades: Array[AbilityUpgrade] = []
	# 创建一个能力升级池副本
	var filtered_upgrades = upgrade_pool.duplicate()
	# 重复两次筛选待升级能力选项
	for i in 2:
		if filtered_upgrades.size() == 0:
			break
		var chosen_upgrade = filtered_upgrades.pick_random() as AbilityUpgrade
		chosen_upgrades.append(chosen_upgrade)
		filtered_upgrades = filtered_upgrades.filter(func (upgrade): return upgrade.id != chosen_upgrade.id)
	
	return chosen_upgrades


#收到选择信号后应用到升级
func on_upgrade_selected(upgrade:AbilityUpgrade):
	apply_upgrade(upgrade)


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

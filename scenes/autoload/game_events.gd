extends Node

signal experience_spot_collected(number: float)
signal ability_upgrades_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged


# 函数名为发射信号，传递一个数值浮点类型  信号发射接口
func emit_experience_spot_collected(number: float):
	experience_spot_collected.emit(number)


# 发射信号升级能力增加
func emit_ability_upgrades_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrades_added.emit(upgrade,current_upgrades)


# 发射信号玩家角色受伤
func emit_player_damaged():
	player_damaged.emit()

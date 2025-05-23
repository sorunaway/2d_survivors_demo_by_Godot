extends CanvasLayer

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene

@onready var card_container: HBoxContainer = %CardContainer


func _ready() -> void:
	get_tree().paused = true


# 获得传输的随机升级，查找并实例化每一个卡片界面
func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	for upgrade in upgrades:
		var card_instance = upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		# 连接每一个卡片的升级选择信号
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade))
		
		
func on_upgrade_selected(upgrade:AbilityUpgrade):
	# 用信号传递已选择的升级参数
	upgrade_selected.emit(upgrade)
	get_tree().paused = false
	queue_free()

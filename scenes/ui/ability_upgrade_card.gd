extends PanelContainer

signal selected

@onready var name_label: Label = $MarginContainer/VBoxContainer/PanelContainer/NameLabel
@onready var description_label: Label = $MarginContainer/VBoxContainer/DescriptionLabel



func _ready() -> void:
	# 连接GUI输入信号
	gui_input.connect(on_gui_input)


# 获取升级技能数据，应用卡片UI描述
func set_ability_upgrade(upgrade:AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


# 当检测到GUI输入信号，发送“已选择”信号
func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		selected.emit()

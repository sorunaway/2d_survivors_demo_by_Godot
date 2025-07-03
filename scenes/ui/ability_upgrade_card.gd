extends PanelContainer

signal selected

@onready var name_label: Label = $MarginContainer/VBoxContainer/PanelContainer/NameLabel
@onready var description_label: Label = $MarginContainer/VBoxContainer/DescriptionLabel

var disabled = false


func _ready() -> void:
	# 连接GUI输入信号
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)

func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT # 入场时透明化
	await get_tree().create_timer(delay).timeout # 延迟
	$AnimationPlayer.play("in")


func play_discard():
	disabled = true
	$AnimationPlayer.play("discard")


# 获取升级技能数据，应用卡片UI描述
func set_ability_upgrade(upgrade:AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func select_card():
	disabled = true
	$AnimationPlayer.play("selected")
	
	# 判定是否为未选中的其他牌，然后播放弃牌动画
	for other_card in get_tree().get_nodes_in_group("upgrade_card"):
		if other_card == self:
			continue
		other_card.play_discard()
		
	await $AnimationPlayer.animation_finished
	selected.emit()



# 当检测到GUI输入信号，发送“已选择”信号
func on_gui_input(event: InputEvent):
	if disabled:
		return
		
	if event.is_action_pressed("left_click"):
		select_card()

func on_mouse_entered():
	if disabled:
		return
	
	$HoverPlayer.play("hover")

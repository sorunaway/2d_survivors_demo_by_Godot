extends PanelContainer


@onready var name_label: Label = $MarginContainer/VBoxContainer/PanelContainer/NameLabel
@onready var description_label: Label = $MarginContainer/VBoxContainer/DescriptionLabel
@onready var progress_bar: ProgressBar = $MarginContainer/VBoxContainer/VBoxContainer/ProgressBar
@onready var purchase_button: Button = $MarginContainer/VBoxContainer/PurchaseButton
@onready var progress_label: Label = %ProgressLabel
@onready var count_label: Label = %CountLabel


var upgrade: MetaUpgrade


func _ready() -> void:
	purchase_button.pressed.connect(on_purchase_button_pressed)
	# 连接GUI输入信号
	gui_input.connect(on_gui_input)


# 获取升级技能数据，应用卡片UI描述
func set_meta_upgrade(upgrade: MetaUpgrade):
	self.upgrade = upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()


func update_progress():
	var current_quantity = 0
	if MetaProgression.save_date["meta_upgrades"].has(upgrade.id):
		current_quantity = MetaProgression.save_date["meta_upgrades"][upgrade.id]["quantity"]
	
	var is_maxed = current_quantity >= upgrade.max_quantity
	var currency = MetaProgression.save_date["meta_upgrade_currency"]
	var percent = currency / upgrade.experience_cost
	percent = min(percent, 1)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1 || is_maxed
	if is_maxed:
		purchase_button.text = "已升满"
	progress_label.text = str(currency) + "/" + str(upgrade.experience_cost)
	
	count_label.text = "等级: %d" % current_quantity


func select_card():
	$AnimationPlayer.play("selected")


# 当检测到GUI输入信号，发送“已选择”信号
func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		select_card()


func on_purchase_button_pressed():
	if upgrade == null:
		return
	
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_date["meta_upgrade_currency"] -= upgrade.experience_cost
	MetaProgression.save()
	#调用所有某组的某方法
	get_tree().call_group("meta_upgrade_card", "update_progress")
	$AnimationPlayer.play("selected")

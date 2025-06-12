extends Node

const SAVE_FILE_PATH = "user://game.save"

var save_date: Dictionary = {
	"meta_upgrade_currency": 0,
	"meta_upgrades":{}
}


func _ready() -> void:
	GameEvents.experience_spot_collected.connect(on_experience_collected)
	load_save_file()


func load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH): # 防止未创建存档文件
		return
	
	var file =FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_date = file.get_var()


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_date)


func add_meta_upgrade(upgrade: MetaUpgrade):
	if !save_date["meta_upgrades"].has(upgrade.id): # 如果尚未创建 则创建新的
		save_date["meta_upgrades"][upgrade.id] = {
			"quantity": 0
		}
	
	save_date["meta_upgrades"][upgrade.id]["quantity"] += 1 # 所选升级数量+1
	print(save_date) # 调试


func on_experience_collected(number: float):
	save_date["meta_upgrade_currency"] += number
	save()

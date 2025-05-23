extends Node

signal experience_updated(current_experience: float, target_experience: float)
signal level_up(current_level: int)

const TARGET_EXPERIENCE_GROWTH = 5

var current_experience = 0
var current_level = 1
var target_experience = 1# 记得改回5


func _ready() -> void:
	# 连接全局信号“经验值获取”到函数
	GameEvents.experience_spot_collected.connect(on_experience_spot_collected)


#信号传递数值 执行增加经验函数
func on_experience_spot_collected(number: float):
	increment_experience(number)
	experience_updated.emit(current_experience, target_experience)
	# 如果达到目标经验值 等级+1 经验值进度更新
	if current_experience == target_experience:
		current_level += 1
		# 升级所需经验值增加常量值
		target_experience += TARGET_EXPERIENCE_GROWTH
		current_experience = 0
		#发更新经验信号和升级信号
		experience_updated.emit(current_experience, target_experience)
		level_up.emit(current_level)



# 增加经验值
func increment_experience(number: float):
	#current_experience += number
	current_experience = min(current_experience + number, target_experience)
	

extends Node
class_name HealthComponent

@export var max_health: float = 10
var current_health: float

signal died
signal health_changed

func _ready() -> void:
	current_health = max_health


 # 受伤函数
func take_damage(damage: float):
	current_health = max(0, current_health - damage)
	health_changed.emit()
	Callable(check_death).call_deferred()


func get_health_percent():
	if max_health <= 0:
		return
	return min(current_health / max_health, 1)


func check_death():
	if current_health == 0:
		emit_signal("died") # died.emit() 这样写也是发信号
		owner.queue_free()

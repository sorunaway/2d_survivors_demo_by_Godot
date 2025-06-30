extends Node
class_name HealthComponent

@export var max_health: float = 10
var current_health: float

signal died
signal health_changed
signal health_decreased

func _ready() -> void:
	current_health = max_health


 # 受伤函数
func take_damage(damage_amount: float):
	current_health = clamp(current_health - damage_amount, 0, max_health)
	health_changed.emit()
	if damage_amount > 0:
		health_decreased.emit()
	Callable(check_death).call_deferred()


func heal(heal_amount):
	take_damage(-heal_amount)


func get_health_percent():
	if max_health <= 0:
		return
	return min(current_health / max_health, 1)


func check_death():
	if current_health == 0:
		emit_signal("died") # died.emit() 这样写也是发信号
		owner.queue_free()

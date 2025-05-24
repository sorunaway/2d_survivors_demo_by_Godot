extends Node

signal arena_difficulty_increased(arena_diffculty: int)

const DIFFICULTY_INTERVAL = 5

@export var end_screen_scene: PackedScene

@onready var arena_timer: Timer = $ArenaTimer

var arena_difficulty = 0


func _ready() -> void:
	arena_timer.timeout.connect(on_arena_timer_timeout)

func _process(delta: float) -> void:
	#总时间-当前难度+1*难度时间间隔 = 每过间隔时间，难度+1 (默认每5秒难度+1)
	var next_time_target = arena_timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	if arena_timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)


func get_time_elapsed():
	return arena_timer.wait_time - arena_timer.time_left


func on_arena_timer_timeout():
	# 计时结束时游戏胜利结算
	var end_screen_scene_intance = end_screen_scene.instantiate()
	add_child(end_screen_scene_intance)

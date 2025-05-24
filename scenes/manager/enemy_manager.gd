extends Node

const SPAWN_RADIUS = 400

@export var basic_enemy_scene : PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager : Node

@onready var timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()


func _ready() -> void:
	enemy_table.add_item(basic_enemy_scene, 10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	for i in 4:
		# 随机刷新位置
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		#检查从玩家位置到待生成点之间的射线是否被物理层阻挡
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
	
		if result.is_empty():
			# 如果没有阻挡
			break
		else:
			#生成方向旋转90度
			random_direction = random_direction.rotated(deg_to_rad(90))
			
	return spawn_position


func on_timer_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemy_scene = enemy_table.pick_item()
	var enemy_node = enemy_scene.instantiate() as Node2D
	
	#添加到实体层 
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy_node)
	enemy_node.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):
	# 难度增加 刷怪加快
	var time_off = (0.1 / 12) * arena_difficulty
	time_off = min(time_off, 0.7)
	timer.wait_time = base_spawn_time - time_off
	
	if arena_difficulty == 6:
		enemy_table.add_item(wizard_enemy_scene, 20)

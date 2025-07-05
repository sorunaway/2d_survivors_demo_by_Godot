extends Node2D

const MAX_RANGE = 120

@onready var hitbox_component: HitboxComponent = $HitboxComponent

var damage_upgrade_range = 0
var base_rotation = Vector2.RIGHT
var fire_position = Vector2.ZERO
var angle_offset = 15.0 # 角度偏移量

func _ready() -> void:
	# 获取player节点
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	# 记录玩家开火时位置
	fire_position = player.global_position
	
	# 获取敌人节点
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.size() == 0:
		return
	
	#else:
		## enemies组内排序最近的敌人
		#enemies.sort_custom(func(a:Node2D, b:Node2D):
			#var a_distance = a.global_position.distance_squared_to(player.global_position)
			#var b_distance = b.global_position.distance_squared_to(player.global_position)
			#return a_distance < b_distance
		#)
	
	#修正方向 对准敌人
	base_rotation = fire_position.direction_to(enemies[0].global_position)
	#添加随机角度偏移
	var random_angle = deg_to_rad(randf_range(-angle_offset, angle_offset))
	base_rotation = base_rotation.rotated(random_angle)
	# 更新弓箭朝向
	rotation = base_rotation.angle()
	
	var tween = create_tween()
	tween.tween_method(
		func(percent): 
			tween_method(percent, MAX_RANGE + damage_upgrade_range),  # 传入升级后的最大射程
		0.0, 
		1.0,
		1.0
	).set_ease(Tween.EASE_OUT)
	tween.tween_callback(queue_free)


func tween_method(percent: float, max_range: float):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var current_range = percent * max_range
	global_position = fire_position + (base_rotation * current_range)

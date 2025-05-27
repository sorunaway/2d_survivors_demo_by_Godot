extends Node2D

const MAX_RADIUS = 140

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var sprite_2d: Sprite2D = $Sprite2D

var base_rotation = Vector2.RIGHT
var fire_position = Vector2.ZERO

func _ready() -> void:
	#var player = get_tree().get_first_node_in_group("player")
	#if player == null:
		#return
	# 发射位置为生成时角色坐标
	#fire_position = player.global_position
	
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, 2.0, 3) # 从0 到 2，持续时间3
	tween.tween_callback(queue_free) # 完成tween后删除


#斧头旋转
func tween_method(rotations: float):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	var percent = rotations / 2 # 换算百分比
	var current_radius = percent * MAX_RADIUS # 百分比*距离
	var current_direction = base_rotation.rotated(rotations * TAU) # 方向旋转
	# 位置 = 玩家位置 + （方向 * 距离） = 螺旋外扩状
	global_position = player.global_position + (current_direction * current_radius)
	sprite_2d.self_modulate.a = 1 - (percent * 0.5)

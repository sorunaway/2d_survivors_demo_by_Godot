extends Node2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var animation_player: AnimationPlayer = $Visuals/AnimationPlayer

var player: Node2D
var target = Vector2.ZERO
var angle = Vector2.ZERO
var is_returning: bool = false
var return_speed = 400.0
var target_player_position: Vector2

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if not player:
		queue_free()
		return
		
	# 阶段一 飞向目标点
	angle = player.global_position.direction_to(target)
	rotation = angle.angle() # 调整方向
	animation_player.play("lauching")
	
	var lauch_tween = create_tween()
	lauch_tween.tween_property(self, "global_position", target, 0.4)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	# 到达位置后执行第二阶段
	lauch_tween.tween_callback(on_reach_target)
	
	
#阶段二 停留
func on_reach_target():
	animation_player.play("expanding")
	await animation_player.animation_finished
	animation_player.play("returning")
	await get_tree().create_timer(0.2).timeout
	start_return()


#阶段三 返回
func start_return():
	is_returning = true
	if player and is_instance_valid(player):
		target_player_position = player.global_position
	#var return_tween = create_tween()
	#return_tween.tween_property(self, "global_position", player.global_position, 0.4)\
	#.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	#
	#return_tween.tween_callback(queue_free)


func _physics_process(delta: float) -> void:
	if is_returning:
		if player and is_instance_valid(player):
			target_player_position = player.global_position
		# 计算玩家方向
		var direction = (target_player_position - global_position).normalized()
		# 向玩家移动
		global_position += direction * return_speed * delta
		# 到达玩家附近释放
		if global_position.distance_squared_to(player.global_position) < 64:
			queue_free()

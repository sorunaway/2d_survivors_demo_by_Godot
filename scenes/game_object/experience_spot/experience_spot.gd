extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_random_audio_player: AudioStreamPlayer2D = $HitRandomAudioPlayer

func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered)
	animated_sprite_2d.animation_finished.connect(on_animation_finished)


func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player") # 获取玩家节点
	if player == null:
		return
	
	global_position = start_position.lerp(player.global_position, percent)
	
	#根据玩家位置判断旋转方向
	#var direction_from_start = start_position.direction_to(player.global_position)
	#var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	#rotation = lerp_angle(rotation, target_rotation, 1 - exp(-get_process_delta_time()))


func collect():
	GameEvents.emit_experience_spot_collected(1)
	animated_sprite_2d.play("dispear")
	hit_random_audio_player.play_random()


func disable_collision():
	collision_shape_2d.disabled = true


func on_area_entered(other_area:Area2D):
	# 在下一个空闲帧调用方法
	Callable(disable_collision).call_deferred()
	
	var tween = create_tween()
	tween.set_parallel() #多个tween同时调用
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.6)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(animated_sprite_2d, "scale", Vector2(1.2, 1.2), 0.1).set_delay(0.5) # 0.5秒延迟后逐渐缩小
	tween.chain() #多个tween串联
	tween.tween_callback(collect)


func on_animation_finished():
	queue_free()

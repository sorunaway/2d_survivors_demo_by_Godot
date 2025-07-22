extends Node

@export var max_speed: int = 40
@export var acceleration: float = 5
@export var deceleration: float = 5


var velocity = Vector2.ZERO
#var knock_speed = 700
var knockback_recovery = 2.0
var knockback = Vector2.ZERO


# 向玩家加速
func accelerate_to_player():
	# 获取所属节点
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return
	
	# 获取玩家节点
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	# 获取玩家离所属节点的方向
	var direction = owner.global_position.direction_to(player.global_position)
	accelerate_in_direction(direction)


# 向目标方向加速
func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * max_speed
	if direction != Vector2.ZERO:
		velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))
	else:
		velocity = velocity.lerp(desired_velocity, 1 - exp(-deceleration * get_process_delta_time()))


# 减速
func decelerate():
	accelerate_in_direction(Vector2.ZERO)


# 移动
func move(character_body: CharacterBody2D):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	character_body.velocity = velocity
	character_body.velocity += knockback
	character_body.move_and_slide()
	velocity = character_body.velocity


func on_hit(angle: Variant, knockback_amount: Variant) -> void:
	knockback = angle * knockback_amount

extends CharacterBody2D

#设置状态机
enum State{IDLE,WANDER,CHASE,HURT}
var state: State = State.IDLE
var player_ref:Node2D = null#缓存玩家引用

#移动相关
@export var ACCELERATION = 500#加速度
@export var MAX_SPEED = 40#最大速度
@export var FRICTION = 200#摩擦力
@export var KNOCKSPEED = 220#击退速度
@export var KNOCKFRICTION = 500#击退摩擦力
@export var WANDER_RANGE: float = 50.0#徘徊范围

var wander_target: Vector2 = Vector2.ZERO#徘徊目标坐标
var knockback = Vector2.ZERO#设置击退

@onready var startPositon = global_position

@onready var animator = $AnimatedSprite2D
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var hurtbox = $HurtBox
@onready var softCollision = $SoftCollision
@onready var hurtAnimation = $HurtAnimation

#const EnemyDeathEffect_scene = preload("res://Effects/enemy_death_effect.tscn")

func _ready() -> void:
	playerDetectionZone.player_exited.connect(_on_player_exited)

func _physics_process(delta: float) -> void:
	seek_player()#检测玩家
	match state: # AI状态逻辑
		State.IDLE:
			_idle_state(delta)
		State.WANDER:
			_wander_state(delta)
		State.CHASE:
			_chase_state(delta)
		State.HURT:
			_hurt_state(delta)
	if Engine.get_frames_drawn() % 2 == 0 && softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 800
	move_and_slide()
	
func _idle_state(delta): # 待机状态
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta) #设置摩擦力
	if randf() < 0.01:  # 1%概率进入徘徊
		state = State.WANDER

func _wander_state(delta):# 徘徊状态
	# 到达目标点或首次进入时生成新目标
	if position.distance_to(wander_target) < 5 || wander_target == Vector2.ZERO:
		wander_target = startPositon + Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * WANDER_RANGE
	#var direction = (wander_target - position).normalized()
	var direction = position.direction_to(wander_target)
	velocity = velocity.move_toward(direction * MAX_SPEED * 0.6, ACCELERATION * delta)  # 徘徊时速度降低
	animator.flip_h = direction.x < 0
	if randf() < 0.01:# 1%概率回到IDLE
		wander_target = Vector2.ZERO# 清除当前徘徊目标坐标
		state = State.IDLE

func _chase_state(delta): # 追寻状态
	#if !player_ref:
		#state = State.IDLE
		#return
	var direction = global_position.direction_to(player_ref.global_position)#设置移动方向为玩家全局坐标-自身全局坐标
	velocity = velocity.move_toward(direction * MAX_SPEED,ACCELERATION * delta)#设置速度
	animator.flip_h = direction.x < 0

func _hurt_state(delta): # 受击状态
	# 击退效果带物理衰减
	knockback = knockback.move_toward(Vector2.ZERO,KNOCKFRICTION*delta)
	velocity = knockback
	# 击退结束后恢复IDLE
	if knockback.length() < 2:
		state = State.IDLE

func seek_player(): # 检测玩家
	# 每10帧检测一次（非每帧）
	if Engine.get_frames_drawn() % 10 == 0 && playerDetectionZone.can_see_player() and not state == State.HURT:
		player_ref = playerDetectionZone.player # 缓存玩家引用
		state = State.CHASE

func _on_player_exited():
	state = State.IDLE

func _on_hurt_box_area_entered(area: Area2D) -> void: # 被攻击时
	#击退逻辑
	var knockback_direction = (global_position - area.global_position).normalized()
	knockback = knockback_direction * KNOCKSPEED  # 击退力度
	state = State.HURT # 进入受击状态
	#伤害处理
	stats.health -= area.damage # 生命值受到伤害
	hurtbox.creat_hit_effect()
	hurtbox.start_invincibility(0.4)

func _on_stats_no_health() -> void:
	#create_enemydeatheffect()
	queue_free()

#func create_enemydeatheffect():#引入死亡特效
	##var EnemyDeathEffect_node = EnemyDeathEffect_scene.instantiate()#实例化
	#get_parent().add_child(EnemyDeathEffect_node)#作为子节点添加
	#EnemyDeathEffect_node.global_position = global_position + Vector2(0,-4)#获取全局位置

func _on_hurt_box_invincibility_started() -> void:
	hurtAnimation.play("Start")

func _on_hurt_box_invincibility_ended() -> void:
	hurtAnimation.play("Stop")

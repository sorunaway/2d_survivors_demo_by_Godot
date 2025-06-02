extends CharacterBody2D

#const MAXSPEED = 100
#const ACCELERATION = 1200
#const DECELERATION = 1800

@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities: Node = $Abilities
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var velocity_component: Node = $VelocityComponent

var number_colliding_bodies = 0
var current_animation: String = "idle"
var last_flip_direction: int = 1 # 初始方向右
var base_speed = 0


func _ready() -> void:
	base_speed = velocity_component.max_speed
	
	# 连接信号
	$HurtArea2D.body_entered.connect(on_body_entered)
	$HurtArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrades_added.connect(on_ability_upgrades_added)
	update_health_display()


func _physics_process(delta: float) -> void:
	# 获得输入向量,死区
	var input_vector = Input.get_vector("move_left","move_right","move_up","move_down", 0)
	
	velocity_component.accelerate_in_direction(input_vector)
	velocity_component.move(self)
	## 处理移动
	#handle_movement(input_vector, delta)
	#move_and_slide()
	# 更新动画和方向
	update_animations(input_vector)
	update_flip_direction(input_vector)


# 动画状态处理判断
func update_animations(input_vector: Vector2):
	# 缓存目标动画状态
	var target_animation = "walk" if input_vector != Vector2.ZERO else "idle"
	if target_animation != current_animation:
		animation_player.play(target_animation)
		current_animation = target_animation


func update_flip_direction(input_vector: Vector2):
	var move_sign = sign(input_vector.x)
	if move_sign != 0 && move_sign != last_flip_direction:
		visuals.scale = Vector2(move_sign, 1)
		last_flip_direction = move_sign


#受伤扣血处理,伤害间隔
func check_deal_damage():
	if number_colliding_bodies <= 0 or !damage_interval_timer.is_stopped():
		return
	health_component.take_damage(1)
	damage_interval_timer.start()


#更新血条
func update_health_display():
	health_bar.value = health_component.get_health_percent()


# 有敌人进入受伤框内，检测伤害
func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()


# 敌人退出区域，区域内产生碰撞的敌人数-1
func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1


# 无敌时间计时器结束,重新检测伤害
func on_damage_interval_timer_timeout():
	check_deal_damage()


# 接收到HP变化，更新HPUI显示
func on_health_changed():
	GameEvents.emit_player_damaged()
	update_health_display()


# 接收到能力升级增加
func on_ability_upgrades_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	#检测所获能力是否为新能力类别
	if ability_upgrade is NewAbility:
		# 实例化并添加新能力
		var new_ability = ability_upgrade as NewAbility
		abilities.add_child(new_ability.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * 0.1)

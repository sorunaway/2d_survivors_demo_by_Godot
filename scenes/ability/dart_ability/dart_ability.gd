extends Node2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var player = get_tree().get_first_node_in_group("player")

var level = 1
var hp = 1
var speed = 200
var damage = 5
var knock_amount = 100
var attack_size = 1.0

var dart_hp = hp

var target = Vector2.ZERO
var angle = Vector2.ZERO


func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle()
	
	#GameEvents.ability_upgrades_added.connect(on_ability_upgrades_added)
	#match level:
		#1:
			#hp = 1
			#speed = 100
			#damage = 5
			#knock_amount = 100
			#attack_size = 1.0


func _physics_process(delta: float) -> void:
	position += angle * speed * delta
	

#func enemy_hit(charge = 1):
	#hp -= charge
	#if hp <= 0:
		#queue_free()


func on_enemy_hit(charge):
	hp -= charge
	if hp <= 0:
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()


#func on_ability_upgrades_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	#if ability_upgrade.id == "dart_damage":
		#hp = 1 + current_upgrades["dart_damage"]["quantity"]

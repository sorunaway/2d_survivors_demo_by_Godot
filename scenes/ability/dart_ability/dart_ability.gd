extends Node2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var player = get_tree().get_first_node_in_group("player")

var hp = 1
var speed = 200
var target = Vector2.ZERO
var angle = Vector2.ZERO


func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle()


func _physics_process(delta: float) -> void:
	position += angle * speed * delta
	


func on_enemy_hit(charge):
	hp -= charge
	if hp <= 0:
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()

extends Node2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var detect_area_2d: Area2D = $DetectArea2D

var hp = 1
var speed = 120
var target = Vector2.ZERO
var angle = Vector2.ZERO
var is_explosion: bool = false


func _ready() -> void:
	detect_area_2d.body_entered.connect(on_enemy_body_entered)
	angle = global_position.direction_to(target)
	rotation = angle.angle()


func _physics_process(delta: float) -> void:
	if ! is_explosion:
		position += angle * speed * delta
	else:
		return


#func on_enemy_hit(charge):
	#is_explosion = true
	#animation_player.play("explosion")
	##hp -= charge
	##if hp <= 0:
		##queue_free()


func _on_timer_timeout() -> void:
	is_explosion = true
	animation_player.play("explosion")


func on_enemy_body_entered(body: Node2D):
	if body.is_in_group("enemy"):
		is_explosion = true
		animation_player.play("explosion")

extends CharacterBody2D

@onready var visuals: Node2D = $Visuals
@onready var velocity_component: Node = $VelocityComponent

var last_flip_direction: int = 1


func _process(_delta: float) -> void:
	# 向主角位置移动
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	update_flip_direction(velocity)


func update_flip_direction(velocity: Vector2):
	var move_sign = sign(velocity.x)
	if move_sign != 0 && move_sign != last_flip_direction:
		visuals.scale = Vector2(-move_sign, 1)
		last_flip_direction = move_sign

extends CharacterBody2D

@onready var velocity_component: Node = $VelocityComponent
@onready var visuals: Node2D = $Visuals
@onready var health_component: HealthComponent = $HealthComponent

var last_flip_direction:int = 1
var is_moving = false


func _physics_process(delta: float) -> void:
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	
	velocity_component.move(self)
	update_flip_direction(velocity)
	

func update_flip_direction(velocity_vector: Vector2):
	var move_sign = sign(velocity_vector.x)
	if move_sign != 0 && move_sign != last_flip_direction:
		visuals.scale = Vector2(move_sign, 1)
		last_flip_direction = move_sign


func set_is_moving(moving: bool):
	is_moving = moving

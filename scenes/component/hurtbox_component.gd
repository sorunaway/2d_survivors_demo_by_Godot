extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

var floating_text_scene = preload("res://scenes/ui/floating_text.tscn")

func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return
	
	if health_component == null:
		return
	
	var hitbox_component = other_area as HitboxComponent
	health_component.take_damage(hitbox_component.damage)
	
	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position = global_position + (Vector2.UP * 16)
	floating_text.start(str(int(hitbox_component.damage))) # 伤害值传入文本

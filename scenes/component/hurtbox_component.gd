extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent
@onready var timer: Timer = $Timer

signal hit(angle, knockback_amount)

var floating_text_scene = preload("res://scenes/ui/floating_text.tscn")


func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return
	
	if health_component == null:
		return
	
	if other_area.owner.has_method("on_enemy_hit"):
		other_area.owner.on_enemy_hit(1)
	
	# 无敌时间
	if !timer.is_processing():
		var hitbox_component = other_area as HitboxComponent
		health_component.take_damage(hitbox_component.damage)
		timer.start()
		
		var floating_text = floating_text_scene.instantiate() as Node2D
		get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
		floating_text.global_position = global_position + (Vector2.UP * 16)
		
		var format_string = "%0.1f"
		if round(hitbox_component.damage) == hitbox_component.damage:
			format_string = "%0.0f"
		floating_text.start(format_string % hitbox_component.damage) # 伤害值传入文本
		
		#var damage = other_area.damage
		var angle = Vector2.ZERO
		var knockback_amount = 30
		var player = get_tree().get_first_node_in_group("player")
		if player == null:
			return
	
		if not other_area.get("angle") == null:
			angle = other_area.angle
		else:
			angle = player.global_position.direction_to(owner.global_position)
	
		if not other_area.get("knockback_amount") == null:
			knockback_amount = other_area.knockback_amount
		
		hit.emit(angle, knockback_amount)
	

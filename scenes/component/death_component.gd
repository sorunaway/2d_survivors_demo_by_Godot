extends Node2D

@export var health_component: Node
@export var sprite: Sprite2D

func _ready() -> void:
	$GPUParticles2D.texture = sprite.texture
	health_component.died.connect(on_died)


func on_died():
	var entities = get_tree().get_first_node_in_group("entities_layer")
	self.reparent(entities, true)
	$AnimationPlayer.play("death")

extends Node

@export_range(0, 1) var drop_percent: float = 0.7
@export var health_component: Node
@export var spot_scene: PackedScene

func _ready() -> void:
	(health_component as HealthComponent).died.connect(on_died)


func on_died():
	if randf() > drop_percent:
		return
	
	if spot_scene == null:
		return
	
	if not owner is Node2D:
		return
	
	var spot_instance = spot_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(spot_instance)
	spot_instance.global_position = (owner as Node2D).global_position

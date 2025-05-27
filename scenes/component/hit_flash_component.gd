extends Node

@export var health_component: Node
@export var sprite: Sprite2D


func _ready() -> void:
	health_component.health_changed.connect(on_health_changed)


func on_health_changed():
	pass

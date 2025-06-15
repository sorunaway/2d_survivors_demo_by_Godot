extends CanvasLayer

var meta_upgrade_card_scene = preload("res://scenes/ui/meta_upgrade_card.tscn")

@export var upgrades: Array[MetaUpgrade]

@onready var grid_container: GridContainer = $MarginContainer/GridContainer


func _ready() -> void:
	for upgrade in upgrades:
		var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_upgrade_card_instance)

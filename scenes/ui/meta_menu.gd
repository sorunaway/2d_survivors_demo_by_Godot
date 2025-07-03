extends CanvasLayer

var meta_upgrade_card_scene = preload("res://scenes/ui/meta_upgrade_card.tscn")

@export var upgrades: Array[MetaUpgrade]

@onready var grid_container: GridContainer = $MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var back_button: Button = $MarginContainer/VBoxContainer/BackButton



func _ready() -> void:
	back_button.pressed.connect(on_back_button_pressed)
	for upgrade in upgrades:
		var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade(upgrade)


func on_back_button_pressed():
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")

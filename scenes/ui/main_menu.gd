extends CanvasLayer

@onready var play_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PlayButton
@onready var option_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionButton
@onready var quit_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton


func _ready() -> void:
	play_button.pressed.connect(on_play_button_pressed)
	option_button.pressed.connect(on_option_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)


func on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main/Main.tscn")
	

func on_option_button_pressed():
	pass


func on_quit_button_pressed():
	get_tree().quit()

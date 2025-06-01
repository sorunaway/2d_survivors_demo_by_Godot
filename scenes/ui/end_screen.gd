extends CanvasLayer


func _ready() -> void:
	get_tree().paused = true
	%RestartButton.pressed.connect(on_restart_button_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)


func set_defeat():
	%TitleLabel.text = "失败"
	%DescriptionLabel.text = "你没能坚持下来"

func on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Main/Main.tscn")


func on_quit_button_pressed():
	get_tree().quit()

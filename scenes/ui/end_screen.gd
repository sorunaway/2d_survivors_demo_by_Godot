extends CanvasLayer

@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer



func _ready() -> void:
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.2)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	get_tree().paused = true
	%ContinueButton.pressed.connect(on_continue_button_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)


func set_defeat():
	%TitleLabel.text = "失败"
	%DescriptionLabel.text = "你没能坚持下来!"
	play_jingle(true)

func play_jingle(defeat: bool = false):
	if defeat == true:
		$DefeatStreamPlayer.play()
	else:
		$VictoryStreamPlayer.play()


func on_continue_button_pressed():
	ScreenTransition.transition_to_scene("res://scenes/ui/meta_menu.tscn")
	get_tree().paused = false


func on_quit_button_pressed():
	get_tree().paused = false
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")

extends CanvasLayer

@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer
@onready var resume_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/ResumeButton
@onready var options_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/OptionsButton
@onready var quit_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/QuitButton

var options_menu_scene = preload("res://scenes/ui/options_menu.tscn")

var is_closing = false


func _ready() -> void:
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size / 2
	resume_button.pressed.connect(on_resume_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	
	$AnimationPlayer.play("in")
	
	var tween = create_tween() # UI框体从0到1放大出现
	tween.tween_property(panel_container, "scale", Vector2.ZERO , 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE , 0.2)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _unhandled_input(event: InputEvent) -> void:
	# 按ESC 关闭界面
	if event.is_action_pressed("pause"):
		close()
		get_tree().root.set_input_as_handled()


func close():
	if is_closing: # 检查是否正在关闭中
		return
	
	is_closing = true
	$AnimationPlayer.play_backwards("in")
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE , 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO , 0.2)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	get_tree().paused = false
	queue_free()


func on_resume_pressed(): # 按按钮也调用关闭
	close()


func on_options_pressed():
	var options_menu_instance = options_menu_scene.instantiate()
	add_child(options_menu_instance)
	options_menu_instance.back_pressed.connect(on_options_back_pressed.bind(options_menu_instance))


func on_quit_pressed():
	get_tree().paused = false
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func on_options_back_pressed(options_menu: Node):
	await get_tree().create_timer(0.1).timeout
	options_menu.queue_free()

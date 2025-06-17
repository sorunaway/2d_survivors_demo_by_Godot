extends CanvasLayer

@onready var play_button: Button = %PlayButton
@onready var upgrades_button: Button = %UpgradesButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton

var options_scene = preload("res://scenes/ui/options_menu.tscn")


func _ready() -> void:
	play_button.pressed.connect(on_play_button_pressed)
	upgrades_button.pressed.connect(on_upgrades_button_pressed)
	options_button.pressed.connect(on_options_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)
	
	MusicPlayer.bgm_player.stop()
	MusicPlayer.menu_stream_player.play()


func on_play_button_pressed():
	MusicPlayer.menu_stream_player.stop()
	
	ScreenTransition.transition() # 转场效果
	await ScreenTransition.transitioned_halfway
	
	MusicPlayer.bgm_player.play()
	get_tree().change_scene_to_file("res://scenes/main/Main.tscn")


func on_upgrades_button_pressed():
	MusicPlayer.menu_stream_player.stop()
	
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway

	get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn")


func on_options_button_pressed():
	#转场效果预留
	#ScreenTransition.transition()
	#await ScreenTransition.transitioned_halfway
	
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))


func on_quit_button_pressed():
	await get_tree().create_timer(0.1).timeout
	get_tree().quit()


func on_options_closed(options_instance: Node):
	await get_tree().create_timer(0.1).timeout
	options_instance.queue_free()

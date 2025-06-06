extends Node


@onready var timer: Timer = $Timer
@onready var menu_stream_player: AudioStreamPlayer = $MenuStreamPlayer
@onready var bgm_player: AudioStreamPlayer = $BGMPlayer


func _ready() -> void:
	bgm_player.finished.connect(on_bgm_finished)
	timer.timeout.connect(on_timeout)


func on_bgm_finished():
	timer.start()


func on_timeout():
	bgm_player.play()

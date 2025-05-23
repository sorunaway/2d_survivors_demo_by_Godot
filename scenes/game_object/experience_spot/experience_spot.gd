extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered)
	animated_sprite_2d.animation_finished.connect(on_animation_finished)


func on_area_entered(other_area:Area2D):
	animated_sprite_2d.play("dispear")
	GameEvents.emit_experience_spot_collected(1)
	audio_stream_player_2d.play()


func on_animation_finished():
	queue_free()

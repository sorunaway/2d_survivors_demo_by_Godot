extends Node2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var animation_player: AnimationPlayer = $Visuals/AnimationPlayer

@onready var player = get_tree().get_first_node_in_group("player") as Node2D

var target = Vector2.ZERO
var angle = Vector2.ZERO

func _ready() -> void:
	angle = player.global_position.direction_to(target)
	rotation = angle.angle()
	var tween = create_tween()
	tween.tween_property(self, "global_position", target, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	animation_player.play("lauching")
	animation_player.play("expanding")
	tween.tween_property(self, "global_position", player.global_position, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE).set_delay(0.3)
	animation_player.play("returning")
	tween.tween_callback(queue_free)

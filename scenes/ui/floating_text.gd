extends Node2D


func _ready() -> void:
	pass


func start(text: String):
	$Label.text = text
	
	var tween = create_tween()
	tween.set_parallel()
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 32), 0.4)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	
	tween.tween_property(self, "global_position", global_position + (Vector2.DOWN * 4), 0.8)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2(0.8, 0.8), 0.8)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5).set_delay(0.3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	tween.chain()
	
	tween.tween_callback(queue_free)
	
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2.ONE * 1.6, 0.2)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property(self, "scale", Vector2.ONE, 0.2)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)

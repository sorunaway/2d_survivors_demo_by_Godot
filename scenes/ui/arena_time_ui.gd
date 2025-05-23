extends CanvasLayer

@export var arena_time_manager:Node
@onready var label: Label = $MarginContainer/Label


func _process(delta: float) -> void:
	if arena_time_manager == null:
		return
	var time_elapsed = arena_time_manager.get_time_elapsed()
	label.text = format_seconds_to_string(time_elapsed)


func format_seconds_to_string(seconds: float):
	var total_seconds = int(seconds)
	var minutes = int(total_seconds / 60.0)  # 使用浮点数除法后转整数
	var remaining_seconds = total_seconds % 60
	return "%02d:%02d" % [minutes, remaining_seconds]

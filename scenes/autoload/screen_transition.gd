extends CanvasLayer

signal transitioned_halfway

var skip_emit = false


func transition():
	$AnimationPlayer.play("default")
	await  transitioned_halfway
	skip_emit = true
	$AnimationPlayer.play_backwards("default")

func emit_transitioned_halfway():
	if skip_emit:
		skip_emit = false
		return
		
	transitioned_halfway.emit()

extends CanvasLayer


signal transitioned

#func _ready():
#	transition()

func transition():
	$ColorRect.visible = true
	$AnimationPlayer.play('fade_to_black')

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'fade_to_black':
		emit_signal('transitioned')
		$AnimationPlayer.play('fade_to_normal')
	if anim_name == 'fade_to_normal':
		$ColorRect.visible = false

extends Node2D

var room = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.hall_exit:
		$Player.position.x = 939
		$Player.position.y = 304
		Global.hall_exit = false
	if Global.up_exit:
		$Player.position.x = 554
		$Player.position.y = -335
		Global.up_exit = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_main_room_body_entered(_body):
	if _body.has_method('player'):
		Global.exit_pos = true
		room = 0
		$transition.transition()


func _on_right_hall_body_entered(_body):
	if _body.has_method('player'):
		Global.hall_exit = true
		room = 1
		$transition.transition()


func _on_upside_body_entered(_body):
	if _body.has_method('player'):
		Global.up_exit = true
		room = 2
		$transition.transition()



func _on_transition_transitioned():
	if room == 0:
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	elif room == 1:
		get_tree().change_scene_to_file("res://scenes/right_zone.tscn")
	elif room == 2:
		get_tree().change_scene_to_file("res://scenes/up_turcia.tscn")

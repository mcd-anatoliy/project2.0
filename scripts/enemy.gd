extends CharacterBody2D


@export var Bullet : PackedScene
@export var speed = 50
@export var gravity = 630
@onready var pid = $poprigunchik
#игрок в области(bool)
var player_chase = false
var player = null
var health = 100
var player_inattack_range = false
var can_take_damage = true
var ubili_pistoletom = false
var can_walk = true
var umer = false

func _physics_process(delta):
	deal_with_damage()
	health_update()
	
	if umer:
		self.queue_free()
	
	
	#гравитация
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#если игрок в области
	if player_chase:
		position += (player.position - position) / speed #преследование игрока
		if can_walk:
			pid.play('walk') #анимация ходьбы
		#поворот бота в зависимости от направления
		if (player.position.x - position.x) < 0:
			pid.flip_h = true
		else:
			pid.flip_h = false
	else:
		pid.play('idle') #если игрок не в области, то проигравается анимация статичного положения

	move_and_slide()

#вход в область отслеживания
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

#выход из области отслеживания
func _on_detection_area_body_exited(_body):
	player = null
	player_chase = false


func enemy():
	pass


func _on_pid_hitbox_body_entered(body):
	if body.has_method("attack"):
		player_inattack_range = true
	if body.has_method('ubiystvo'):
		ubili_pistoletom = true



func _on_pid_hitbox_body_exited(body):
	if body.has_method("attack"):
		player_inattack_range = false


func deal_with_damage():
	if player_inattack_range and Global.player_current_attack:
		if can_take_damage:
			health -= 20
			pid.play('damage')
			can_walk = false
			can_take_damage = false
			$attack_cooldown.start()
			if health <= 0:
				pid.play("death")
				$Timer.start()
	if ubili_pistoletom:
		health -= 10
		pid.play('damage')
		can_walk = false
		ubili_pistoletom = false
		$attack_cooldown.start()
		if health <= 0:
			pid.play("death")
			$Timer.start()


func _on_attack_cooldown_timeout():
	can_take_damage = true
	can_walk = true


func health_update():
	var healthbar = $healthbar
	healthbar.value = health
	if health >= 200:
		healthbar.visible = false
	else:
		healthbar.visible = true


func _on_timer_timeout():
	umer = true
	can_walk = false

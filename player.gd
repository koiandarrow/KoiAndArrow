extends CharacterBody2D

@onready var joystick = $"../HUD/HBoxContainer/Joystick"
@onready var ability_timer = $"../HUD/AbilityTimer"

const SPEED = 600.0
const BOOST_SPEED = 1400.0
const JUMP_VELOCITY = -400.0

signal corn_point
signal gold_corn_point
signal arrow_hit
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var isSelected = true
var leftBlocked = false
var screen_size
var is_dashing = false
var last_direction
var is_shielded = false
var ability_cooldown = false
var time_left = 3

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	var velocity = Vector2.ZERO
	
	if !ability_cooldown:
		if Input.is_action_pressed("dash"):
			_on_dash()
		if Input.is_action_pressed("shield"):
			_on_shield()
	
	# WASD Controls
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if (velocity != Vector2(0,0)):
			last_direction = velocity
			
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		var target1 = velocity * 10
		look_at(target1)
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	# WASD Controls End
	
	var direction = joystick.posVector
	if (is_dashing):
		print("dashing")
		if (last_direction == null):
			last_direction = Vector2.ZERO
			last_direction.x = 1;
		velocity = last_direction * BOOST_SPEED
		var target = velocity * 10
		look_at(target)
	else:
		if (direction != Vector2(0,0)):
			last_direction = direction
		if direction:
			velocity = direction * SPEED
			var target = velocity * 10
			look_at(target)
		else:
			velocity = Vector2(0,0)
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(body):
	print("collided")
	if(body.collision_layer==2):
		print("collision layer 2")
		if body.is_in_group("arrow"):
			print("arrow")
			body.hide()
			body.queue_free()
			if !is_shielded:
				arrow_hit.emit()
		else:
			if(body.name!="Player"):
				print("ate corn")
				if body.is_in_group("goldcorn"):
					print("goldcorn")
					gold_corn_point.emit()
				else:
					corn_point.emit()
				body.hide()
				body.queue_free()
		
func _on_area_entered(area):
	print("area")
	#if(area.collision_layer==2):
		#print("collision layer 2")
		#if(area.name!="Player"):
			#print("ate corn")
			#if area.is_in_group("goldcorn"):
				#print("goldcorn")
				#gold_corn_point.emit()
			#else:
				#corn_point.emit()
			#area.hide()
			#area.queue_free()

func _on_dash():
	ability_timer.show()
	print("dashing")
	is_dashing = true
	$BoostTimer.start()
	ability_cooldown = true
	$AbilityTimer.start()
	#var velocity = Vector2.ZERO
	#velocity = last_direction * 1800.0
	#print(last_direction)
	#position += velocity * 10
	#position = position.clamp(Vector2.ZERO, screen_size)

func _on_shield():
	ability_timer.show()
	print("shield")
	is_shielded = true
	$Shield.show()
	$ShieldTimer.start()
	ability_cooldown = true
	$AbilityTimer.start()
	
	
func _on_boost_timer_timeout():
	is_dashing = false
	
func _on_shield_timer_timeout():
	is_shielded = false
	$Shield.hide()
	
func _on_ability_timer_timeout():
	print("TIMEOUT")
	time_left = time_left - 1
	ability_timer.text = str(time_left)
	if time_left < 1:
		time_left = 3
		$AbilityTimer.stop()
		ability_timer.hide()
		ability_cooldown = false

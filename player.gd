extends CharacterBody2D

@onready var joystick = $"../HUD/HBoxContainer/Joystick"

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

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	var velocity = Vector2.ZERO
	
	# WASD Controls
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	# WASD Controls End
	
	var direction = joystick.posVector
	if (is_dashing):
		print("dashing")
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
	print("dashing")
	is_dashing = true
	$BoostTimer.start()
	#var velocity = Vector2.ZERO
	#velocity = last_direction * 1800.0
	#print(last_direction)
	#position += velocity * 10
	#position = position.clamp(Vector2.ZERO, screen_size)

func _on_shield():
	print("shield")
	is_shielded = true
	$ShieldTimer.start()
	
func _on_boost_timer_timeout():
	is_dashing = false
	
func _on_shield_timer_timeout():
	is_shielded = false

extends CharacterBody2D

@onready var joystick = $"../HUD/HBoxContainer/Joystick"

const SPEED = 600.0
const BOOST_SPEED = 1400.0
const JUMP_VELOCITY = -400.0

signal corn_point
signal gold_corn_point
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var isSelected = true
var leftBlocked = false
var screen_size
var is_dashing = false
var last_direction

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	var velocity = Vector2.ZERO
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
	if(area.collision_layer==2):
		print("collision layer 2")
		if(area.name!="Player"):
			print("ate corn")
			if area.is_in_group("goldcorn"):
				print("goldcorn")
			area.hide()
			area.queue_free()

func _on_dash():
	print("dashing")
	is_dashing = true
	$BoostTimer.start()
	#var velocity = Vector2.ZERO
	#velocity = last_direction * 1800.0
	#print(last_direction)
	#position += velocity * 10
	#position = position.clamp(Vector2.ZERO, screen_size)
	

func _on_boost_timer_timeout():
	is_dashing = false

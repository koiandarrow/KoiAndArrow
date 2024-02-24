extends CharacterBody2D

@onready var joystick = $"../HUD/HBoxContainer/Joystick"

const SPEED = 600.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var isSelected = true
var leftBlocked = false


func _physics_process(delta):
	var velocity = Vector2.ZERO
	var direction = joystick.posVector
	if direction:
		velocity = direction * SPEED
		var target = velocity * 10
		look_at(target)
	else:
		velocity = Vector2(0,0)
	if isSelected:
		if leftBlocked and velocity.x > 0:
			velocity.x = 0
		position += velocity * delta
		#position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(body):
	print("collided")
	if(body.collision_layer==2):
		print("collision layer 2")
		if(body.name!="Player"):
			print("ate corn")
			if body.is_in_group("goldcorn"):
				print("goldcorn")
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

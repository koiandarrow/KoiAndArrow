extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("corn is ready")
	$AnimatedSprite2D.play("default")
	$Timer.start()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	

func _on_timer_timeout():
	hide()
	queue_free()

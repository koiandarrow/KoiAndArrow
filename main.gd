extends Node

@export var corn_scene: PackedScene
@export var arrow_scene: PackedScene

var arrowMinSpeed = 150.0
var arrowMaxSpeed = 250.0

var corn_points = 0
var time_left = 45

func _ready():
	#$CornTimer.start()
	#$ArrowTimer.start()
	#$Player.start($StartPosition1.position)
	print("hey")
	
func start_game():
	time_left = 5
	corn_points = 0
	$Player.show()
	$HUD/HBoxContainer/Joystick.show()
	$CornTimer.start()
	$ArrowTimer.start()
	$GameTimer.start()
	$HUD/Score.show()
	$HUD/Timer.show()
	$HomeScreen/Dash.show()
	$HomeScreen/Shield.show()
	$HUD/Score2.hide()

func _on_corn_timer_timeout():
	$Player.visible = true
	var corn = corn_scene.instantiate()
	var corn_map = get_node("HUD/HBoxContainer/CornMap")
	var corn_spawn_loc = get_node("HUD/HBoxContainer/CornMap/CornSpawn")
	var size = Vector2.ZERO
	var newLoc = Vector2.ZERO
	size = corn_spawn_loc.shape.extents
	#print(randi())
	#print(size.x)
	#print(size.x/2)
	var centerpos = corn_map.position + corn_spawn_loc.position
	var random = RandomNumberGenerator.new()
	random.randomize()
	var newy = random.randi_range(centerpos.y-size.y, centerpos.y+size.y)
	var newx = random.randi_range(centerpos.x-size.x, centerpos.x+size.x)
	newLoc.y = newy
	newLoc.x = newx
	corn.position = newLoc
	#print(corn.position)
	corn.add_to_group("corn")
	add_child(corn)
	
func _on_arrow_timer_timeout():
	# Create a new instance of the Mob scene.
	var arrow = arrow_scene.instantiate()

	# Choose a random location on Path2D.
	var arrow_spawn_location = get_node("HUD/HBoxContainer/ArrowPath/ArrowSpawn")
	arrow_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = arrow_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	arrow.position = arrow_spawn_location.global_position
	#print("mob loc")
	#print(arrow_spawn_location.position)

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	arrow.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(arrowMinSpeed, arrowMaxSpeed), 0.0)
	arrow.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	arrow.add_to_group("arrow")
	add_child(arrow)

func _on_game_timer_timeout():
	time_left = time_left - 1
	$HUD/Timer.text = str(time_left)
	if time_left < 1:
		end_game()
		
func end_game():
	get_tree().call_group("arrow", "queue_free")
	get_tree().call_group("corn", "queue_free")
	$Player.hide()
	$HUD/HBoxContainer/Joystick.hide()
	$CornTimer.stop()
	$ArrowTimer.stop()
	$GameTimer.stop()
	$HomeScreen/Dash.hide()
	$HomeScreen/Shield.hide()
	$HomeScreen/StartButton.text = "Play Again"
	$HomeScreen/StartButton.show()
	$HUD/Score.hide()
	$HUD/Score2.text = str(corn_points)
	$HUD/Score2.show()
	
func add_points():
	corn_points = corn_points + 1
	$HUD/Score.text = str(corn_points)

func lose_points():
	corn_points = corn_points - 5
	$HUD/Score.text = str(corn_points)

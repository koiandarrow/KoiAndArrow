extends Node

@export var corn_scene: PackedScene
@export var arrow_scene: PackedScene

var arrowMinSpeed = 150.0
var arrowMaxSpeed = 250.0

func _ready():
	$CornTimer.start()
	$ArrowTimer.start()
	#$Player.start($StartPosition1.position)
	print("hey")

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
	print(corn.position)
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
	print("mob loc")
	print(arrow_spawn_location.position)

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	arrow.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(arrowMinSpeed, arrowMaxSpeed), 0.0)
	arrow.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(arrow)

extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
signal dash
signal shield
var cornScore = 0
var onMainMenu = true

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Press Start to Play Again"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
#func update_score(score):
	#$ScoreLabel.text = str(score)
#
#func update_corn_score(score):
	#$CornCounter.text = str(score)
	#
#func update_fish_counter(fish):
	#$FishCounter.text = str(fish)
	#
func _on_start_button_pressed():
	$StartButton.hide()
	$MultiplayerButton.hide()
	$Message.hide()
	#$ScoreLabel.show()
	#$CornCounter.show()
	#$FishCounter.show()
	start_game.emit()
	
func _on_multiplayer_button_pressed():
	$StartButton.hide()
	$Message.hide()
	$MultiplayerButton.hide()
	$MultiplayerButton2.hide()
	start_server()
	
func _on_multiplayer2_button_pressed():
	$StartButton.hide()
	$Message.hide()
	$MultiplayerButton.hide()
	$MultiplayerButton2.hide()
	start_client()
	
func start_server():
	var hole_puncher = preload('res://addons/Holepunch/holepunch_node.gd').new()
	# your rendezvous server IP or domain
	hole_puncher.rendevouz_address = "ip"
	# the port the HolePuncher python application is running on
	hole_puncher.rendevouz_port = 443
	add_child(hole_puncher)
	# Generate a unique ID for this machine
	var player_id = OS.get_unique_id()
	#var player_id = "dummy"
	var game_code = "12345"
	var is_host = true
	var player_host = 'host' if is_host else 'client'
	var traversal_id = '%s_%s' % [OS.get_unique_id(), player_host]
	hole_puncher.start_traversal(game_code, true, player_id)
	# Yield an array of [own_port, host_port, host_ip]
	# Start a host
	var result = await hole_puncher.hole_punched
	var my_port = result[0]

	var peer = ENetMultiplayerPeer.new()
	peer.create_server(my_port, 1)
	get_tree().set_network_peer(peer)
	start_game.emit()

func start_client():
	var hole_puncher = preload('res://addons/Holepunch/holepunch_node.gd').new()
	# your rendezvous server IP or domain
	hole_puncher.rendevouz_address = "ip"
	# the port the HolePuncher python application is running on
	hole_puncher.rendevouz_port = 443
	add_child(hole_puncher)
	# Generate a unique ID for this machine
	var player_id = OS.get_unique_id()
	#var player_id = "dummy"
	var game_code = "12345"
	var is_host = false
	var player_host = 'host' if is_host else 'client'
	var traversal_id = '%s_%s' % [OS.get_unique_id(), player_host]
	hole_puncher.start_traversal(game_code, false, player_id)
	# Yield an array of [own_port, host_port, host_ip]
	# Start a host
	var result = await hole_puncher.hole_punched
	var host_ip = result[2]
	var host_port = result[1]
	var own_port = result[0]

	var peer = ENetMultiplayerPeer.new()
	peer.create_client(host_ip, host_port, 0, 0, own_port)
	get_tree().set_network_peer(peer)
	
	
func _on_dash_pressed():
	dash.emit()
	
func _on_shield_pressed():
	shield.emit()

#
#func _on_message_timer_timeout():
	#$Message.hide()
#
#func _on_player_ate_corn(points):
	#print("adding corn")
	#cornScore = cornScore + points
	#$CornCounter.text = str(cornScore)
	#
#func _on_info_button_pressed():
	#if onMainMenu:
		#$InfoButton.text = "Back To Menu"
		#$Message.text = "Select A Fish To Move with Joystick. Dodge Arrows and Collect Corn"
		#onMainMenu = false
	#else:
		#$InfoButton.text = "How To Play"
		#$Message.text = "Koi and Arrow"
		#onMainMenu = true

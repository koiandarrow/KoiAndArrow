extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
signal dash
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
	$Message.hide()
	#$ScoreLabel.show()
	#$CornCounter.show()
	#$FishCounter.show()
	start_game.emit()
	
func _on_dash_pressed():
	dash.emit()

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

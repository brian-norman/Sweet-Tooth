extends CanvasLayer


signal start_game
signal music_volume(value)


var high_score = 0
var high_score_text = "High Score: %s"


# Called when the node enters the scene tree for the first time.
func _ready():
	load_high_score()


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	
	show_message("Get the candy!")
	$Message.show()
	
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	$HighScoreLabel.show()


func update_score(score):
	$ScoreLabel.text = str(score)
	if score > high_score:
		high_score = score
		set_new_high_score(high_score)


func _on_StartButton_pressed():
	$StartButton.hide()
	$HighScoreLabel.hide()
	emit_signal("start_game")


func _on_MessageTimer_timeout():
	$Message.hide()


func load_high_score():
	# Load data from a file.
	var config = ConfigFile.new()
	var err = config.load("user://high_score.cfg")
	
	# Only create if doesn't already exist
	if err != OK:
		config.set_value("score", "high", 0)
		config.save("user://high_score.cfg")
	
	high_score = config.get_value("score", "high")
	$HighScoreLabel.text = high_score_text % str(high_score)


func set_new_high_score(score):
	var config = ConfigFile.new()
	var err = config.load("user://high_score.cfg")
	
	if err != OK:
		return
	
	config.set_value("score", "high", score)
	config.save("user://high_score.cfg")
	$HighScoreLabel.text = high_score_text % str(high_score)


func _on_HSlider_value_changed(value):
	emit_signal("music_volume", value)

extends Node


export (PackedScene) var Candy
export (PackedScene) var Barrier

var score
var time_start = 0
var time_now = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_now = OS.get_unix_time()
	$CandyTimer.wait_time = 1/speed_multiplier()
	$BarrierTimer.wait_time = 1/speed_multiplier()


func new_game():
	score = 0
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready...")
	$Player.show()
	$Player/AnimatedSprite.animation = "fly"
	$Player/AnimatedSprite.play()
	$Music.play()
	time_start = OS.get_unix_time()


func game_over():
	$Music.stop()
	$CandyTimer.stop()
	$BarrierTimer.stop()

	$HUD.show_game_over()
	$Player.hide()
	get_tree().call_group("candy", "queue_free")
	get_tree().call_group("barrier", "queue_free")
	$CandyTimer.wait_time = 1
	$BarrierTimer.wait_time = 1.5


func _on_CandyTimer_timeout():
	$SpawnPath/SpawnLocation.offset = randi()
	var candy = Candy.instance()
	candy.speed *= speed_multiplier()
	add_child(candy)
	candy.position = $SpawnPath/SpawnLocation.position


func _on_BarrierTimer_timeout():
	$SpawnPath/SpawnLocation.offset = randi()
	var barrier = Barrier.instance()
	barrier.speed *= speed_multiplier()
	if randf() > 0.5:
		barrier.rotation = PI / 2
	add_child(barrier)
	barrier.position = $SpawnPath/SpawnLocation.position
	barrier.position.x += 400


func _on_StartTimer_timeout():
	$CandyTimer.start()
	$BarrierTimer.start()


func _on_Player_candy_entered():
	score += 1
	$CandySound.play()
	$HUD.update_score(score)


func _on_Player_barrier_entered():
	$ExplosionSound.play()
	game_over()


func speed_multiplier():
	var starting_difficulty = -4
	var scaling_factor = 2.8
	var time_elapsed = float(time_now - time_start)    # In Seconds
	var multiplier = log((time_elapsed + 30)/4.9) * scaling_factor + starting_difficulty

	return multiplier


func _on_HUD_music_volume(value):
	var volume = 0
	if value == 0:
		volume = -51
	elif value == 10:
		volume = -30.8
	elif value == 20:
		volume = -22.4
	elif value == 30:
		volume = -17.1
	elif value == 40:
		volume= -13.1
	elif value == 50:
		volume = -10.0
	elif value == 60:
		volume = -7.4
	elif value == 70:
		volume =  -4.9
	elif value == 80:
		volume =  -3.2
	elif value == 90:
		volume = -1.3
	else:
		volume = 0
	
	$Music.volume_db = volume
	$ExplosionSound.volume_db = volume
	$CandySound.volume_db = volume

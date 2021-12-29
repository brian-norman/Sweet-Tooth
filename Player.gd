extends Area2D


export var speed = 400
var screen_size


signal candy_entered
signal barrier_entered


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	
	if Input.is_action_pressed("ui_down") || Input.is_key_pressed(KEY_S):
		velocity.y += 1
	
	if Input.is_action_pressed("ui_up") || Input.is_key_pressed(KEY_W):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	
	if position.y < 0:
		position.y = screen_size.y
	if position.y > screen_size.y:
		position.y = 0


func _on_Player_body_entered(body):
	if body.is_in_group("candy"):
		emit_signal("candy_entered")
		body.queue_free()
	elif body.is_in_group("barrier"):
		body.queue_free()
		$AnimatedSprite.animation = "explosion"


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "explosion":
		$AnimatedSprite.stop()
		emit_signal("barrier_entered")

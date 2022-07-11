extends RigidBody2D


export var speed = 200


func explode():
	$Sprite.visible = false
	$Explosion.restart()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2(-1, 0)
	
	velocity = velocity.normalized() * speed
	
	position += velocity * delta
	
	if position.x < -100:
		queue_free()

extends RigidBody2D


export var speed = 200


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2(-1, 0)
	
	velocity = velocity.normalized() * speed
	
	position += velocity * delta
	
	if position.x < -100:
		queue_free()

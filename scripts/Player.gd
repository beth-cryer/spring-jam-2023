extends KinematicBody

export var speed = 1.25;
export var fall_acceleration = 5.0;

var target_velocity = Vector3.ZERO

func _ready():
	pass

func _physics_process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("idle")
	
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	move_and_slide(target_velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	

extends Node2D

@export var acceleration = 256
@export var max__run_speed = 64
@export var max_fall_speed = 100
@export var max_dash_speed = 80 
@export var friction = 0.1
@export var gravity = 512
@export var jump_force = 0
var velocity = Vector2.ZERO

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	velocity.y += gravity * delta
	clamp(velocity.y, -max__fall_speed, max__fall_speed)

	var x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if x_input != 0:
		velocity.x += x_input * acceleration
		velocity.x = clamp(velocity.x, -max__run_speed, max__run_speed)
		sprite.flip_h = x_input < 0
	velocity = move_and_slide(velocity, Vector2.UP)

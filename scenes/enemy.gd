extends Area2D

@export var gravity_enemy = 512

@onready var Anime = $AnimatedSprite2D

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta):
	
	velocity.y += gravity_enemy * delta
	Anime.play("move")
	
	if Global.player_position.x > 3500:
		if Global.player_position.x < position.x:
			position.x += -30 * delta
		else:
			Anime.flip_h = true
			position.x += 30 * delta
		
func _on_body_entered(body):
	if body.name == "Player":
		print("hit")
		Global.hit = true

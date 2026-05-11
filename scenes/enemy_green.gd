extends CharacterBody2D

@export var gravity_enemy = 400
@export var move_speed = 30

@onready var HitArea = $Hit
@onready var Anime = $AnimatedSprite2D

var spawn_pos: Vector2 

func _ready() -> void:
	HitArea.connect("body_entered", Callable(self, "_on_hit_area_entered"))

func _physics_process(delta):
	
	if abs(position.x - Global.player_position.x) > 440:
		teleport_to_spawn()
	
	if abs(position.y - Global.player_position.y) > 500:
		teleport(Vector2(spawn_pos.x, spawn_pos.y - 300))

	# 重力
	velocity.y += gravity_enemy * delta
	
	# 動き
	if Global.player_position.x < position.x:
		velocity.x = -move_speed
		Anime.flip_h = false
	else:
		velocity.x = move_speed
		Anime.flip_h = true
	
	# アニメーション
	Anime.play("move")

	move_and_slide()
	
func _on_hit_area_entered(body):
	if body.name == "Player":
		var direction = sign(body.position.x - position.x)
		body.knockback(direction)
		Global.hit = true
		
func position_reset(x1, x2, target_position: Vector2) -> void: #落下リセット
	if position.y >= 1200 and x1 < position.x and position.x < x2:
		position = target_position

func teleport(tp_position: Vector2):
	position = tp_position
	
func teleport_to_spawn():
	position = spawn_pos

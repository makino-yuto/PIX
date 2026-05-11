extends CharacterBody2D

#シーンの読み込み
var main_scene: PackedScene = preload("res://scenes/mainmenu.tscn")

@export var acceleration = 200
@export var max_speed = 64
@export var max_dash_speed = 128
@export var friction = 0.5
@export var gravity = 230
@export var jump_force = 230
@export var air_resistance = 0.02
@export var friction_value = 0.5

@onready var sprite = $AnimatedSprite2D
@onready var JumpSE = $JumpSE
@onready var RunSE = $RunSE
@onready var DashSE = $DashSE
@onready var Cloud = $Cloud
@onready var Damage = $DamageSE

var is_jumping = false
var can_input = true # ← 入力できるかどうか
var can_input_2 = true
var knockback_timer = 0.0
var is_dead = false

func _physics_process(delta):
	# デフォルト摩擦
	friction_value = 0.5  
	
	# --- 空中・地上での挙動を分ける ---
	var on_ground = is_on_floor()

	var current_accel = acceleration
	var current_friction = friction

	if not on_ground:
		current_accel *= 0.9   # 空中では加速を弱める
		current_friction *= 0.1  # 空中では摩擦をほぼ効かせない

	# TileMap を取得
	var tilemap = get_parent().get_node("Layer0")  # Layer0 が TileMap であること
	if tilemap:
		var tile_pos = tilemap.local_to_map(global_position)
		var tile_data = tilemap.get_cell_tile_data(tile_pos)
		if tile_data:
			var custom = tile_data.get_custom_data("friction")
			if custom != null:
				friction_value = custom
	friction = friction_value  # 最終的に friction に反映

	
	
	
	
	if is_dead:
		return  # 死亡中は移動や操作を処理しない
	

		
	# --- 通常の操作処理 ---
	
	if Global.current_hp <= 0 and not is_dead:
		is_dead = true
		can_input = false
		can_input_2 = false
		$AnimatedSprite2D.play("death")
		
		var t = get_tree().create_timer(4.0)
		t.connect("timeout", Callable(self, "_on_death_timer_timeout"))
		return  # 死亡中は他の処理を止める
	
	if Global.goaled_1:
		velocity.y = -1250
		Global.goaled_1 = false
	
	Global.player_position = position #グローバルに位置を共有
	
	position_reset(-1000, 300, 1200, 1500, (Vector2(150, 200))) #落下のリセット
	position_reset(300, 1000, 1200, 1500,(Vector2(680, 200)))
	position_reset(1000, 3000, 1200, 1500, (Vector2(1100, 200)))
	position_reset(3000, 4000, 1200, 1500, (Vector2(3750, 200)))
	
	position_reset(1800, 2200, 0, 100, Vector2(3000, 1200))
	position_reset(2800, 3150, 1300, 1400, Vector2(2000, 300))
	position_reset(3200, 4300, 1300, 1400, Vector2(3150, 300))
	position_reset(3900, 4100, 0, 100, Vector2(4950, 1200))
	position_reset(4800, 5150, 1300, 1400, Vector2(3950, 300))
	position_reset(5150, 6150, 1300, 1400, Vector2(5150, 300))
	velocity.y += gravity * delta

	#操作入力
	if not can_input:
		knockback_timer -= delta
		sprite.play("hit")
		if knockback_timer <= 0.0:
			can_input = true
			friction = 0.5
			knockback_timer = -1
			
	var x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	var dash = Input.get_action_strength("dash")
	var can_jump = is_on_floor()
	
	if position.x > 700:
		Global.can_use_jump = true
	if position.x > 1000:
		Global.can_use_dash = true
	
	if Input.is_action_just_pressed("jump") and can_jump and Global.can_use_jump and can_input and can_input_2:
		$JumpSE.play()
		velocity.y += -jump_force
		is_jumping = true
		
	if is_jumping and Input.is_action_pressed("jump"):
		gravity = 350
		
	if Input.is_action_just_released("jump") or is_on_floor() or velocity.y > 0:
		gravity = 700
	
	if x_input != 0 and can_input and can_input_2:
		# 横移動中は常に run を再生
		sprite.play("run")
		velocity.x += x_input * current_accel * delta
		# ダッシュ中かで上限を決めて制限
		if dash and Global.can_use_dash:
			velocity.x = clamp(velocity.x, -max_dash_speed, max_dash_speed)
			sprite.speed_scale = 2
		else:
			velocity.x = clamp(velocity.x, -max_speed, max_speed)
			sprite.speed_scale = 1
		# 真偽値で向き
		sprite.flip_h = x_input < 0
	else:
		# 停止中は idle
		velocity.x = lerp(velocity.x, 0.0, current_friction)
		sprite.play("idle")
		sprite.speed_scale = 1.0

	move_and_slide()
	
func position_reset(x1, x2, y1, y2, target_position: Vector2) -> void: #落下リセット
	if x1 < position.x and position.x < x2:
		if y1 < position.y and position.y < y2:
			position = target_position

func position_teleport(target_position: Vector2) -> void: #ただのテレポート
	position = target_position

func knockback(direction: int) -> void:
	Global.current_hp -= 1
	Damage.play()
	var power = 500
	friction = 0.0
	velocity.x = power * direction
	velocity.y = power * -0.1
	can_input = false
	knockback_timer = 0.3

func _on_death_timer_timeout():
	GameManager.load_main_scene()

extends Node2D

@onready var Choice = $AnimatedSprite2D
@onready var Select_SE = $Select_SE
@onready var BGM = $BGM
@onready var Rejection_SE = $Rejection_SE
@onready var Decision_SE = $Decision_SE

func _ready() -> void:
	Choice.play("roll")
	BGM.play()
	
func _process(delta: float) -> void:
	#メニューの操作
	if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("up"):
		Select_SE.play()
	
	if Input.is_action_just_pressed("down") and Global.Main_choice == 1:
		Global.Main_choice = 2
	elif Input.is_action_just_pressed("down") and Global.Main_choice == 2:
		Global.Main_choice = 3
	elif Input.is_action_just_pressed("down") and Global.Main_choice == 3:
		Global.Main_choice = 1
	elif Input.is_action_just_pressed("up") and Global.Main_choice == 1:
		Global.Main_choice = 3
	elif Input.is_action_just_pressed("up") and Global.Main_choice == 2:
		Global.Main_choice = 1
	elif Input.is_action_just_pressed("up") and Global.Main_choice == 3:
		Global.Main_choice = 2

	# カーソル位置の変更
	if Global.Main_choice == 1:
		Choice.offset = Vector2(297.865, 322.495)
	elif Global.Main_choice == 2:
		Choice.offset = Vector2(297.865, 347.505)
	elif Global.Main_choice == 3:
		Choice.offset = Vector2(297.865, 371.325)
		
	#決定
	if Input.is_action_just_pressed("jump") and Global.Main_choice == 1:
		Decision_SE.play()
		await get_tree().create_timer(1.0).timeout
		Global.current_hp = 5
		GameManager.load_game_scene()
		
	elif Input.is_action_just_pressed("jump") and Global.Main_choice in [2, 3]:
		Rejection_SE.play()

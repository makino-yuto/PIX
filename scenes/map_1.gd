extends Node2D

#シーンの読み込み
var main_scene: PackedScene = preload("res://scenes/mainmenu.tscn")

var velocity_Tutorial := Vector2.ZERO
#BGM
@onready var bgm = $BGM  # AudioStreamPlayer
@onready var bgm_2 = $BGM2
@onready var CoinSE = $CoinSE
@onready var Tutorial_dash = $Tutorial_dash
@onready var Tutorial_text_dash = $Tutorial_text_dash
@onready var Tutorial_jump = $Tutorial_text_jump
@onready var Tutorial_move = $Tutorial_text_move
@onready var spawn_manager = $SpawnManager
@onready var goal_manager = $GoalManager
#type1は赤、type2は緑

func _ready():
	bgm.play()  # シーン開始時に再生
	bgm_2.play()

	goal_manager.connect("goal_reached", Callable(self, "_on_goal_reached"))
	#selfはつまりmap_1.gdのこと
	
func _on_goal_reached(player):
	Global.goaled_1 = true

	
func _process(delta: float) -> void:

	#BGM	
	bgm.volume_db = Global.bgm_db
	bgm_2.volume_db = Global.bgm_2_db
	
	#Tutorial
	Tutorial_jump.hide()
	Tutorial_dash.hide()
	Tutorial_move.show()
	Tutorial_text_dash.hide()
	if Global.can_use_dash:
		Tutorial_dash.show()
		Tutorial_text_dash.show()
		Tutorial_dash.play("run")
		Tutorial_dash.position.x += 150 * delta
	if Global.can_use_jump:
		Tutorial_jump.show()
	if Tutorial_dash.position.x > 3000:
		Tutorial_dash.hide()
		
		
func _on_collected():
	CoinSE.stop()  # ← これでリセット
	CoinSE.play()
	#いまのところ
	

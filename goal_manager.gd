# GoalManager.gd
extends Node2D

signal goal_reached # プレイヤーがゴールしたときの通知

@export var goal_scene: PackedScene  # 個別のゴールArea2Dのシーン
@export var positions: Array = [
	Vector2(1931, 629)
]    # 配置座標のリスト

func _ready():
	for pos in positions:
		var goal = goal_scene.instantiate()
		goal.position = pos
		add_child(goal)
		goal.connect("goal_reached", Callable(self, "_on_goal_signal"))
	
# プレイヤー情報を受け取るように
# GoalManager.gd
func _on_goal_signal(player):  # ← player を受け取る
	emit_signal("goal_reached", player)  # そのまま中継

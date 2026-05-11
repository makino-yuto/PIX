extends Node2D

@export var EnemyScene1: PackedScene
@export var EnemyScene2: PackedScene

# 配置座標リスト（どの位置にどの敵を出すか）
@export var spawn_data: Array = [
	{"pos": Vector2(400, 620.0), "type": 1},
	{"pos": Vector2(800, 620.0), "type": 2},
	{"pos": Vector2(1200, 620.0), "type": 1},
	{"pos": Vector2(1600, 620.0), "type": 2}
]

var enemies = []

func _ready():
	for data in spawn_data:
		var scene = EnemyScene1 if data.type == 1 else EnemyScene2 #シーンの判別
		var enemy = scene.instantiate() #そのシーンをインスタンス化
		enemy.position = data.pos #変数の設定
		enemy.spawn_pos = data.pos
		add_child(enemy)
		enemies.append(enemy)

func spawn_enemy(pos: Vector2, type: int):
	var scene = EnemyScene1 if type == 1 else EnemyScene2
	if scene == null:
		return
	
	var enemy = scene.instantiate()
	enemy.position = pos
	add_child(enemy)
	enemies.append(enemy)

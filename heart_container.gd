extends Node2D

@onready var template_heart = $TextureRect
var hearts: Array = []

func _process(delta: float) -> void:
	template_heart.hide()  # 元のテンプレートは非表示
	for i in range(Global.current_hp):
		var heart = template_heart.duplicate(true)  # 深いコピー
		heart.position = Vector2(0, i * 10)  # 100px間隔で縦に並べる
		heart.show()
		add_child(heart)
		hearts.append(heart)
		
	set_hp(Global.current_hp)

func set_hp(current_hp: int):
	for i in range(len(hearts)):
		hearts[i].visible = i < current_hp

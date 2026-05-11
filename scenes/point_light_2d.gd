var light = Light2D.new()
light.texture = preload("res://light/default_light.png")
light.energy = 2.0
light.color = Color(1, 0.9, 0.7) # 暖色系
light.mode = Light2D.MODE_ADD
add_child(light)

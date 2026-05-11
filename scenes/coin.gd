extends Area2D
#anime
@onready var coin_animation  = $AnimatedSprite2D


signal collected #coinをとると発火するシグナル

func _ready():
	coin_animation.play("stay")
	connect("body_entered", Callable(self, "_on_body_entered"))
#body_enteredは何かがぶつかったときに発火するシグナル

func _on_body_entered(body):
	if body.name == "Player":
		print("got coin")
		emit_signal("collected")
		queue_free()
	

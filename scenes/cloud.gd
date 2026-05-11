extends Node2D

@export var speed = 70
@export var min_y = 450
@export var max_y = 550

@onready var cloud1 = $cloud1
@onready var cloud2 = $cloud2
@onready var cloud3 = $cloud3

func _ready():
	cloud1.position = Vector2(0, randf()*(max_y-min_y) + min_y)
	cloud2.position = Vector2(1000, randf()*(max_y-min_y) + min_y)
	cloud3.position = Vector2(2000, randf()*(max_y-min_y) + min_y)

func _process(delta):
	cloud1.position.x -= speed * delta
	cloud2.position.x -= speed * delta
	cloud3.position.x -= speed * delta

	if cloud1.position.x < -cloud1.texture.get_width():
		cloud1.position.x = 2000
		cloud1.position.y = randf()*(max_y-min_y) + min_y

	if cloud2.position.x < -cloud2.texture.get_width():
		cloud2.position.x = 2000
		cloud2.position.y = randf()*(max_y-min_y) + min_y

	if cloud3.position.x < -cloud3.texture.get_width():
		cloud3.position.x = 2000
		cloud3.position.y = randf()*(max_y-min_y) + min_y

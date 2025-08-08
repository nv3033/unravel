extends StaticBody3D

# Скорость перемещения
var speed = 200

func _ready():
	await(get_tree().create_timer(2.0).timeout)
	queue_free()

func _process(delta):
	position.x += speed * delta

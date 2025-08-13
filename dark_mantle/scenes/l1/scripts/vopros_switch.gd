extends Node3D

@export var rotation_speed = 50.0
@onready var player_near = false
@export var max_size = 0.398
@export var scale_speed = 0.05
@onready var player = $"../CharacterBody3D"
@onready var switch = $"../switch"
@onready var wall = $"../wall"
@onready var switch_pressed = false
@onready var ui = $ui

func _process(delta):
	#rotate_y(deg_to_rad(rotation_speed * delta))
	if player_near == true:# and scale.x < max_size:
		ui.visible = true
		#scale = Vector3(scale.x+scale_speed, scale.y+scale_speed, scale.z+scale_speed)
	if player_near == false:# and scale.x > 0:
		ui.visible = false
		#scale = Vector3(scale.x-scale_speed, scale.y-scale_speed, scale.z-scale_speed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and player_near and !switch_pressed:
		switch.rotate_x(deg_to_rad(180))
		switch_pressed = !switch_pressed
		wall.position = Vector3(-2, 3, -11)

func _on_area_3d_2_body_exited(body: Node3D) -> void:
	pass

func _on_area_3d_2_body_entered(body: Node3D) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") == true:
		player_near = true
		print("player entered")


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") == true:
		player_near = false
		print("player exited")

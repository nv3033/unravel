extends CharacterBody3D

@export var speed = 5.0
@export var mouse_sensitivity = 0.005
@export var camera_shake_amplitude = 0.02
@export var camera_shake_frequency = 10.0
@export var camera_shake_offset = 0.0
@onready var camera_pivot = $Camera_pivot
@onready var can_move = true
@onready var current_weapon_index = 0
@onready var weapons_count = 1
#var velocity = Vector3.ZERO
var is_moving = false
@onready var weapons= [$Camera_pivot/weapons/cross,
$Camera_pivot/weapons/Knife2,
$Camera_pivot/weapons/Pistol,
$Camera_pivot/weapons/Shotgun_DoubleBarrel]



func weapon_select(event):
	if event.is_action_pressed("ui_page_up") or event.is_action_pressed("ui_page_down"):
		weapons[current_weapon_index].get_node("AnimationPlayer").play("down")
		await weapons[current_weapon_index].get_node("AnimationPlayer").animation_finished
		
		if event.is_action_pressed("ui_page_up"):
			current_weapon_index += 1
			if current_weapon_index >= weapons_count:
				current_weapon_index = 0
		if event.is_action_pressed("ui_page_down"):
			current_weapon_index -= 1
			if current_weapon_index < 0:
				current_weapon_index = weapons_count -1
		
		print("Current weapon: ", current_weapon_index)
		
		for i in range(0, weapons.size()):
			if i != current_weapon_index:
				weapons[i].visible = false
			else:
				weapons[i].visible = true
		
		weapons[current_weapon_index].get_node("AnimationPlayer").play_backwards("down")



func rotate_camera(event):
	rotate_y(-event.relative.x * mouse_sensitivity)
	camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI/2, PI/2)
	


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED  # Захватываем мышь



func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_camera(event)
	weapon_select(event)



func shake_camera(delta):
	if is_moving:
		camera_shake_offset += delta * camera_shake_frequency
		camera_pivot.position.x = sin(camera_shake_offset) * camera_shake_amplitude
	else:
		camera_pivot.position.x = 0



func move_input(delta):
	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("ui_down"):
		input_dir.y += 1
	if Input.is_action_pressed("ui_up"):
		input_dir.y -= 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1

	is_moving = input_dir.length() > 0

	if input_dir.length() > 0:
		input_dir = input_dir.normalized()

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if can_move == true:
		velocity.y = -1
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed



func _physics_process(delta):
	move_input(delta)
	move_and_slide()
	shake_camera(delta)

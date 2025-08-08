extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 5
var mouse_sensitivity = 0.002

var camera
var pistol_animation_player
var spawner
var bullet

func _ready():
	camera = $Camera
	pistol_animation_player = $Pistol/AnimationPlayer
	spawner = $Spawner
	bullet = load("res://models/weapons/bullets/pistol_bullet.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	velocity.y += -gravity * delta
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
	if event is InputEventMouseButton and event.is_action_pressed("ui_fire"):
		pistol_animation_player.play("fire")
		var new_instance = bullet.duplicate()
		#get_parent().add_child(new_instance)
		new_instance.rotation = rotation
		new_instance.position = spawner.position
		

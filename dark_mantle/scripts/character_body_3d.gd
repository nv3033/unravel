extends CharacterBody3D

@export var speed = 5.0
@export var mouse_sensitivity = 0.005
@export var camera_shake_amplitude = 0.02
@export var camera_shake_frequency = 10.0
@export var camera_shake_offset = 0.0
@onready var camera_pivot = $Camera_pivot
#var velocity = Vector3.ZERO
var is_moving = false

func _ready():
 Input.mouse_mode = Input.MOUSE_MODE_CAPTURED  # Захватываем мышь

func _unhandled_input(event):
 if event is InputEventMouseMotion:
  rotate_y(-event.relative.x * mouse_sensitivity)
  camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
  camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI/2, PI/2)

func _physics_process(delta):
 # Получаем ввод с клавиатуры
 var input_dir = Vector2.ZERO
 if Input.is_action_pressed("ui_down"):
  input_dir.y += 1
 if Input.is_action_pressed("ui_up"):
  input_dir.y -= 1
 if Input.is_action_pressed("ui_left"):
  input_dir.x -= 1
 if Input.is_action_pressed("ui_right"):
  input_dir.x += 1

 # Определяем, движется ли персонаж
 is_moving = input_dir.length() > 0

 # Нормализуем ввод, если он есть
 if input_dir.length() > 0:
  input_dir = input_dir.normalized()

 # Преобразуем ввод в направление движения в мировом пространстве
 var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

 # Рассчитываем скорость
 velocity.x = direction.x * speed
 velocity.z = direction.z * speed

 # Применяем гравитацию (если нужна)
 velocity.y = -1

 # Двигаем персонажа
 move_and_slide()

 # Камера трясется при движении
 if is_moving:
  camera_shake_offset += delta * camera_shake_frequency
  camera_pivot.position.x = sin(camera_shake_offset) * camera_shake_amplitude
 else:
  camera_pivot.position.x = 0

extends Node3D

@onready var omni_light = $OmniLight3D  # Предполагаем, что узел OmniLight3D называется "OmniLight3D"

@export var min_energy: float = 1.0 # Минимальное значение energy
@export var max_energy: float = 3.0 # Максимальное значение energy
@export var min_interval: float = 0.5 # Минимальный интервал изменения energy
@export var max_interval: float = 2.0 # Максимальный интервал изменения energy

var timer = Timer.new()
var current_interval: float

func _ready():
 # Добавляем таймер к текущему узлу
 add_child(timer)
 timer.one_shot = true
 timer.timeout.connect(_on_timer_timeout)

 # Устанавливаем initial interval
 current_interval = randf_range(min_interval, max_interval)

 # Запускаем таймер
 timer.start(current_interval)

func _on_timer_timeout():
 # Меняем energy на случайное значение
 omni_light.light_energy = randf_range(min_energy, max_energy)

 # Рассчитываем новый интервал
 current_interval = randf_range(min_interval, max_interval)

 # Запускаем таймер снова
 timer.start(current_interval)

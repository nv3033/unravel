extends Node3D

func _process(delta: float) -> void:
	look_at($"../CharacterBody3D".position)

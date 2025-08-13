extends Node

func _process(delta: float) -> void:
	if self.visible == true:
		get_node("Area3D/CollisionShape3D").disabled = false
	else:
		get_node("Area3D/CollisionShape3D").disabled = true
		

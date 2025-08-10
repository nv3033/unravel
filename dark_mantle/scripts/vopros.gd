extends Node3D

@export var rotation_speed = 50.0
@onready var player_near = false
@export var max_size = 0.398
@export var scale_speed = 0.05
@export var json_path = "res://dialogues/l1mage.json"
@onready var page = 0
@onready var data = load_json_to_string_array(json_path)
@onready var background = $"../CharacterBody3D/Camera_pivot/Control/CanvasLayer/ColorRect"
@onready var text_label = $"../CharacterBody3D/Camera_pivot/Control/CanvasLayer/RichTextLabel"
@onready var player = $"../CharacterBody3D"
@export var print_speed = 1
@onready var output_in_work = false

func _ready() -> void:
	scale = Vector3(0, 0, 0)

func _process(delta):
	rotate_y(deg_to_rad(rotation_speed * delta))
	if player_near == true and scale.x < max_size:
		scale = Vector3(scale.x+scale_speed, scale.y+scale_speed, scale.z+scale_speed)
	if player_near == false and scale.x > 0:
		scale = Vector3(scale.x-scale_speed, scale.y-scale_speed, scale.z-scale_speed)
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and output_in_work == false and player_near:
		if page == 0:
			background.visible = true
			text_label.visible = true
			player.can_move = false
			show_text(data[page])
		elif page == data.size():
			background.visible = false
			text_label.visible = false
			player.can_move = true
		else:	
			show_text(data[page])
		page += 1
		

func show_text(str: String):
	output_in_work = true
	text_label.text = ""
	for i in str:
		text_label.text += i
		await get_tree().create_timer(print_speed).timeout
	output_in_work = false
	

func load_json_to_string_array(json_path: String) -> Array[String]:
	var string_array: Array[String] = []
	
	var file = FileAccess.open(json_path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()

		var json_data = JSON.parse_string(json_string)
		for item in json_data:
			if typeof(item) == TYPE_STRING:
				string_array.append(item)
			else:
				printerr("Non-string element found in JSON array: ", item)
	else:
		printerr("Error opening file: ", json_path)

	return string_array

func _on_area_3d_2_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") == true:
		player_near = false
		print("player exited")


func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") == true:
		player_near = true
		print("player entered")

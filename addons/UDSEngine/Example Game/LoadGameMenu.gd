extends Control

@onready var loadFileSelect : Resource = load("res://addons/UDSEngine/Example Game/LoadFileSelect.tscn")
@onready var file_list_container := $VBox1/Scroll1/VBox1

func _ready() -> void:
	
	var save_files_arr : Array = AU3ENGINE.get_save_files()
	for i in save_files_arr:
		var save_file_dict : Dictionary = AU3ENGINE.import_data(AU3ENGINE.save_game_path + i)
		var loadFileSelect_new :Node = loadFileSelect.instantiate()
		loadFileSelect_new.get_node("Load").set_text("Load File " + i)
		var map_path : String = save_file_dict["Global Data"][AU3ENGINE.global_settings_profile]["Current Map"]
		loadFileSelect_new.file_name = i
		loadFileSelect_new.parent_container = self
		loadFileSelect_new.get_node("ColorRect/VBoxContainer/MapNameInput").set_text(await AU3ENGINE.get_map_name(map_path))
		
		file_list_container.add_child(loadFileSelect_new)


func _on_ReturnToTitle_button_up() -> void:
	remove_load_menu()

func remove_load_menu():
	queue_free()

func clear_save_file_list():
	for i in file_list_container.get_children():
		i.queue_free()

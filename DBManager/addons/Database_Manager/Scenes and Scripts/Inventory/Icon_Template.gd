extends "res://addons/Database_Manager/Scenes and Scripts/InputScene.gd"
tool

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var texture_button = $HBoxContainer/TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	type = "IconDisplay"
#	inputNode = $HBoxContainer/Input


func _on_TextureButton_button_up():
	var par = get_main_tab(self)
	par.get_node("Popups/FileDialog").visible = true
	par.get_node("Popups/FileDialog").set_show_hidden_files(false)

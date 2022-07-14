@tool
extends InputEngine


var fileSelectedNode :Node
var popupDialog : FileDialog

func _init() -> void:
	type = "6"


#func _ready():
#	inputNode = $HBoxContainer/ColorRect/Input
#	labelNode = $Label/HBox1/Label_Button


func _on_TextureButton_button_up():
	on_text_changed(true)
	var FileSelectDialog = load("res://addons/UDSEngine/Database_Manager/Scenes and Scripts/UI_Navigation_Scenes/FileSelectDialog.tscn")
	fileSelectedNode = FileSelectDialog.instantiate()
	var par = get_main_tab(self)
	par.get_node("Popups").visible = true
	par.get_node("Popups/FileSelect").visible = true
	par.get_node("Popups/FileSelect").add_child(fileSelectedNode)
	var popupDialog : Node = fileSelectedNode.get_node("FileSelectDialog")
	popupDialog = fileSelectedNode.get_node("FileSelectDialog")
	popupDialog.show_hidden_files = true
	popupDialog.set_access(2)
	popupDialog.set_filters(Array(["*.png"]))
	popupDialog.file_selected.connect(_on_FileDialog_file_selected)
#	popupDialog.connect("file_selected", self, "_on_FileDialog_file_selected")
#	popupDialog.connect("hide", self, "remove_dialog")
	popupDialog.cancelled.connect(remove_dialog)


func remove_dialog():
	var par = get_main_tab(self)
	var list_node :Node = par.get_node("Popups/ListInput")
	if list_node.get_child_count() == 0:
		par.get_node("Popups").visible = false
	par.get_node("Popups/FileSelect").visible = false
	fileSelectedNode.queue_free()
	


func _on_FileDialog_file_selected(path):
	remove_dialog()
	var par = get_main_tab(self)
#	par.popup_main.visible = false
	var dir = Directory.new() #
	var new_file_name = path.get_file() #
	var new_file_path = par.table_save_path + par.icon_folder + new_file_name #
	var curr_icon_path : Node = inputNode #
#	var file_dialog_signal = "file_selected"
	if par.is_file_in_folder(par.table_save_path + par.icon_folder, new_file_name): # #Check if selected folder is Icon folder and has selected file
		curr_icon_path.set_normal_texture(load(str(new_file_path)))
#		save_all_db_files(current_table_name)
	else:
		dir.copy(path, new_file_path)
		if !par.is_file_in_folder(par.icon_folder, new_file_name):
			print("File Not Added")
		else:
			print("File Added")
			par.refresh_editor()
			await get_tree().create_timer(.25).timeout
#			var tr = Timer.new()
#			tr.set_one_shot(true)
#			add_child(tr)
#			tr.set_wait_time(.25)
#			tr.start()
#			yield(tr, "timeout")
#			tr.queue_free()
			curr_icon_path.set_normal_texture(load(str(new_file_path)))
#	refresh_data(Item_Name)
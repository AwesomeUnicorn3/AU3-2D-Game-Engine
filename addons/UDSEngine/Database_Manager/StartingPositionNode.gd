@tool
extends Sprite2D

var current_position :Vector2 = Vector2.ZERO
var previous_position:Vector2 = Vector2.ZERO
var position_updated :bool = true
var DBENGINE = DatabaseEngine.new()
var editor 
var save_table_wait_index :int = 0
var set_position_button

func _ready():
	
	if get_tree().get_edited_scene_root() != null:
	#Set current position based on Global Data info
		
		var global_data_dict = DBENGINE.import_data("Global Data")
		current_position = DBENGINE.convert_string_to_vector(global_data_dict[await DBENGINE.get_global_settings_profile()]["Player Starting Position"])
		set_position(current_position)
		previous_position = current_position
		#print(current_position)
	else:
		queue_free()


func update_starting_position_in_profile(CurrentPosition):
	var editor  = load("res://addons/UDSEngine/EditorEngine.gd").new()
	
	var global_data_dict = DBENGINE.import_data("Global Data")
	global_data_dict[await DBENGINE.get_global_settings_profile()]["Player Starting Position"] = CurrentPosition
	#print(global_data_dict[await DBENGINE.get_global_settings_profile()]["Player Starting Position"])
	await DBENGINE.save_file(DBENGINE.table_save_path + "Global Data" + DBENGINE.table_file_format, global_data_dict)
	var main_node = editor.get_editor_interface().get_editor_main_screen().get_node("AU3ENGINE")
#	print(main_node.name)
#	main_node._ready()
#	main_node.update_dictionaries()
#	main_node.reload_buttons()
	#main_node.table_list.get_child(0)._on_TextureButton_button_up()
#	main_node.get_node("Tabs").get_node("Global Data").update_dictionaries()
#	main_node.get_node("Tabs").get_node("Global Data").reload_buttons()
#	main_node.get_node("Tabs").get_node("Global Data").table_list.get_child(0)._on_TextureButton_button_up()
	position_updated = true
	editor.get_editor_interface().save_scene()
	var UDS_main_node: Control = await DBENGINE.return_to_AU3Engine()
	UDS_main_node._ready()
	#DBENGINE.return_to_AU3Engine()

func _process(delta):
	if position != previous_position:
		current_position = position
		previous_position = position
		position_updated = false
		if save_table_wait_index != 200:
			save_table_wait_index = 200
		
	elif save_table_wait_index >= 1:
		save_table_wait_index -= 1
	
	elif save_table_wait_index == 0 and !position_updated:
		position_updated = true
		update_starting_position_in_profile(current_position)

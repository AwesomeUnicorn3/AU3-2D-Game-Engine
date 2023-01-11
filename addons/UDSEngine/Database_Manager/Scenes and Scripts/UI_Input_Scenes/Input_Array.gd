@tool
extends InputEngine

var parent
var action_string_button
var action_control
var key_id 
#var is_new_key :bool = false
var input_dict :Dictionary = {}
var options_dict :Dictionary = {}


func _init() -> void:
	type = "17"


func startup():
	parent = get_parent()
	key_id = parent.name


func _get_input_value():

	input_data = {}
	options_dict["action"] = $ActionSelection.selectedItemName
	input_data["options_dict"] = options_dict
	var id :int = 1
	var curr_input_dict :Dictionary = {}
	for child in $Scroll1/Input.get_children():
		var input_node = child.get_child(1)
		curr_input_dict[str(id)] = input_node.get_input_value()
		id += 1
	input_data["input_dict"] = curr_input_dict

	return input_data


func _set_input_value(node_value):
	if typeof(node_value) == 4:
		node_value = str_to_var(node_value)
	input_data = node_value
	options_dict = input_data["options_dict"]
	$ActionSelection.populate_list()
	var action_name_id = $ActionSelection.get_id(options_dict["action"])
	$ActionSelection.select_index(action_name_id)
	set_input_data()



func delete_selected_key(index:String):
	input_dict.erase(index)
	for key in input_dict.size():
		var str_key = str(key + 1)
		if !input_dict.has(str_key):
			if input_dict.has(str(key + 2)):
				var next_command = input_dict[str(key + 2)]
				input_dict[str_key] = next_command
				input_dict.erase(str(key + 2))
	_set_input_value(input_data)

			


func add_new_key():
	var next_index :String = str(input_dict.size() + 1)
	var action_type :String = options_dict["action"]
	var action_id :String = DBENGINE.get_input_type_id_from_name(action_type)
	var default_dict  = DBENGINE.get_default_value(action_id)
	input_dict[next_index] = default_dict
	input_data["input_dict"] = input_dict
	_set_input_value(input_data)


func set_input_data():
	input_dict = input_data["input_dict"]
	for child in $Scroll1/Input.get_children():
		child.queue_free()
#	await get_tree().create_timer(0.1).timeout
	for index in input_dict:
		var current_dict :Dictionary
		if typeof(input_dict) != TYPE_DICTIONARY:
			current_dict = str_to_var(input_dict[index])
		else:
			if typeof(input_dict[index]) == TYPE_STRING:
				current_dict = str_to_var(input_dict[index])
			else:
				current_dict = input_dict[index]
		var input_type :String = DBENGINE.get_input_type_id_from_name(options_dict["action"])
		var next_scene = DBENGINE.get_input_type_node(input_type).instantiate()
		var node_value = input_dict[index]
		#instantiate a container with a delete button
		var input_control_node :HBoxContainer = load("res://addons/UDSEngine/Database_Manager/Scenes and Scripts/UI_Input_Scenes/InputArray_Node_Field.tscn").instantiate()
		#add new container to Scroll1/input
		$Scroll1/Input.add_child(input_control_node)
		#add new input node to new_container
		DBENGINE.add_input_node(1, 1, index, current_dict, input_control_node,  null, node_value, input_type)
		next_scene.set_name(index)
		input_control_node.set_name(index)
		input_control_node.array_item_delete.connect(delete_selected_key)
		#connect new_container delete signal to delete_selected_key
		#be sure to emit the signal with the input_node name as the index arguement

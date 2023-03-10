@tool
extends EditorPlugin

const MainPanel = preload("res://addons/UDSEngine/UDS_Main.tscn")
var main_panel_instance
var toolbar = preload("res://addons/UDSEngine/Event_Manager/Event Tools.tscn").instantiate()


func _init():
	add_autoload_singleton('AU3ENGINE', "res://addons/UDSEngine/au3engine_singleton.gd")
#	add_autoload_singleton('Quest', "res://addons/Quest_Manager/Quest_Scripts.gd")


func _enter_tree():
	print("Plugin Has Entered the Chat")
	main_panel_instance = MainPanel.instantiate()
	main_panel_instance.set_name("AU3ENGINE")
	# Add the main panel to the editor's main viewport.
	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)
	var mainPanel = get_editor_interface().get_editor_main_screen().get_node("AU3ENGINE")
# Hide the main panel. Very much required.
	_make_visible(false)
	var icon =preload("res://Data/png/AU3Icon.png") #get_editor_interface().get_base_control().get_theme_icon("CharacterBody2D", "EditorIcons")
	add_custom_type("AU3 Event", "CharacterBody2D", preload("res://addons/UDSEngine/Example Game/Event.gd"), icon)
#	icon = get_editor_interface().get_base_control().get_theme_icon("Button", "EditorIcons")
	add_custom_type("AU3 UI Button", "TextureButton", preload("res://addons/UDSEngine/UI_Manager/au3_ui_button.gd"), icon)
	add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, toolbar)
	
	connect_singals()
	toolbar.visible = false


func _exit_tree():
	if main_panel_instance:
		main_panel_instance.queue_free()
	if toolbar:
		toolbar.queue_free()


func _has_main_screen():
	return true


func _get_plugin_name():
	return "AU3 Engine"


func _get_plugin_icon():
	return preload("res://Data/png/AU3Icon.png")
#	return get_editor_interface().get_base_control().get_theme_icon("Node", "EditorIcons")


func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible


func _refresh_data():
	get_editor_interface().get_resource_filesystem().scan()


var selected_node  = null
func _process(delta: float) -> void:
	var selected_nodes :Array = get_editor_interface().get_selection().get_selected_nodes()
	if selected_nodes.size() == 1:
		var current_selection :Node = selected_nodes[0]
		if !is_instance_valid(selected_node):
			selected_node = current_selection
		if selected_node != current_selection:
			selected_node = current_selection
			if current_selection.has_method("show_event_toolbar_in_editor"):
				current_selection.show_event_toolbar_in_editor(current_selection.name)
				toolbar.event_Node = current_selection
				toolbar.visible = true
				toolbar.get_node("HBoxContainer/Edit_Event_Button").visible = true
				toolbar.get_node("HBoxContainer/Assign_Function").visible = false
				
			elif current_selection.has_method("show_UIMethod_selection_in_editor"):
				toolbar.visible = true
				toolbar.get_node("HBoxContainer/Assign_Function").visible = true
				toolbar.get_node("HBoxContainer/Edit_Event_Button").visible = false
				
			else:
				toolbar.get_node("HBoxContainer/Edit_Event_Button").visible = false
				toolbar.get_node("HBoxContainer/Assign_Function").visible = false
				toolbar.visible = false
	else:
		toolbar.visible = false
		toolbar.get_node("HBoxContainer/Edit_Event_Button").visible = false
		toolbar.get_node("HBoxContainer/Assign_Function").visible = false
		selected_node = null


func connect_singals():
	pass

#func _apply_changes():
#	print("APPLY CHANGES")
#	main_panel_instance.when_editor_saved()
	
func _save_external_data():
	print("SAVE EXTERNAL DATA")
	main_panel_instance.when_editor_saved()

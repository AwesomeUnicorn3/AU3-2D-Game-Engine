extends Control
tool
export var label_text = ""
var labelNode
var inputNode
var itemName = ""
var default
var type = ""
var table_name = ""
var table_ref = ""

func get_all_nodes(node):
	var node_array = []
	var input = false
	var label = false


	for i in get_children():
		if i.name == "Label":
			label = true
			node_array.append(i)
		elif i.name == "Input":
			node_array.append(i)
			input = true
	
		if i.get_child_count() > 0:
			for j in i.get_children():
				if j.name == "Label":
					label = true
					node_array.append(j)
				elif j.name == "Input":
					node_array.append(j)
					input = true
					
				if j.get_child_count() > 0:
					for k in j.get_children():
						if k.name == "Label":
							label = true
							node_array.append(k)
						elif k.name == "Input":
							node_array.append(k)
							input = true

	return node_array


func _ready():
	itemName = self.name
	var node_array = get_all_nodes(self)
	for i in node_array:
		if i.name == "Label":
			labelNode = i
#			print(itemName, " ", i.name)
		elif i.name == "Input":
			inputNode = i
#			print(itemName, " ", i.name)
#		else:
#			print(itemName, " ", i.name)

	if label_text == "":
		labelNode.set_text(itemName)
	else:
		labelNode.set_text(label_text)

	connect_signals()

func label_pressed():
	var keyName = get_main_tab(self).Item_Name
	var fieldName = labelNode.text
	if fieldName == "Key": 
		OS.set_clipboard("udsmain.Static_Game_Dict['" + table_ref + "']['" + keyName + "']")
	else:
		OS.set_clipboard("udsmain.Static_Game_Dict['" + table_ref + "']['" + keyName + "']['" + fieldName + "']")
	labelNode.release_focus()


func get_main_tab(par):
	#Get main tab scene which should have the popup container and necessary script
	while !par.get_groups().has("Tab"):
		par = par.get_parent()
	return par

func on_mouse_entered():
	
	if get_main_tab(self).get("selected_field_name"):
		get_main_tab(self).selected_field_name = labelNode.text

func connect_signals():
	labelNode.connect("pressed", self, "label_pressed")
	inputNode.connect("mouse_entered", self, "on_mouse_entered")
	labelNode.connect("mouse_entered", self, "on_mouse_entered")
	self.connect("mouse_entered", self, "on_mouse_entered")
	

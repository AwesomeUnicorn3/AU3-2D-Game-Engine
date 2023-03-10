extends Node2D
signal update_events

var map_dict :Dictionary
var ysort_node
var player_node
var player_interaction_area
var event_array :Array = []
var BGM_Player :AudioStreamPlayer = AudioStreamPlayer.new()
var bgm_stream :String
var bgm_volume :float
var bgm_pitch :float
#var bgm_loop :bool

func _ready():
	add_child(BGM_Player)
	ysort_node = Node2D.new()
	add_child(ysort_node)
	ysort_node.y_sort_enabled = true
	event_array = find_children("*", "EventHandler", true)
	var map_event_dict :Dictionary = {}
	#AU3ENGINE.set_current_map(self)
	
	player_node = await AU3ENGINE.get_player_node()
	player_interaction_area = await AU3ENGINE.get_player_interaction_area()
	for event_node in event_array:
		map_event_dict[event_node.name] = event_node
		update_events.connect(event_node.refresh_event_data)
		event_node.map_node = self
		event_node.player_node = player_node
		event_node.player_interaction_area = player_interaction_area
		remove_child(event_node)
		ysort_node.add_child(event_node)
	await AU3ENGINE.map_data_updated
	map_dict = await AU3ENGINE.get_map_dict()
	map_dict = map_dict[AU3ENGINE.current_map_key]
	get_bgm_values()
	set_bgm()
	#Create map dictionary in event save files if none exist
	var current_map_name : String = AU3ENGINE.current_map_key
	if !AU3ENGINE.Dynamic_Game_Dict["Event Save Data"].has(current_map_name):
			AU3ENGINE.Dynamic_Game_Dict["Event Save Data"][current_map_name] = {}
	else:
		#check for deleted events
		var event_save_dict :Dictionary = AU3ENGINE.Dynamic_Game_Dict["Event Save Data"][current_map_name].duplicate(true)
		for event in event_save_dict:
			if !map_event_dict.has(event):
				AU3ENGINE.Dynamic_Game_Dict["Event Save Data"][current_map_name].erase(event)
	var newgame  = AU3ENGINE.get_field_value("Global Data",await AU3ENGINE.get_global_settings_profile(), "NewGame")
	if newgame == true:
		var starting_position = AU3ENGINE.convert_string_to_vector(AU3ENGINE.Static_Game_Dict["Global Data"][await AU3ENGINE.get_global_settings_profile()]["Player Starting Position"])
		player_node.set_position(starting_position)
		AU3ENGINE.set_save_data_value("Global Data", await AU3ENGINE.get_global_settings_profile(), "NewGame", false)
	await AU3ENGINE.move_to_map_Ysort(self)
	if self.has_node("TileMap"):
		await AU3ENGINE.move_to_map_Ysort(self, $TileMap, self)
	AU3ENGINE.emit_signal("map_loaded")


func save_event_data():
	for event_node in event_array:
		if !event_node == null:
			event_node.update_event_data()


func get_bgm_values():
	var bgm_dict :Dictionary = str_to_var(map_dict["BGM"])
	bgm_stream = bgm_dict["stream"]
	bgm_volume = AU3ENGINE.convert_string_to_type(bgm_dict["volume"])
	bgm_pitch = AU3ENGINE.convert_string_to_type(bgm_dict["pitch"])


func set_bgm(BGM_path : String = bgm_stream, volume :float = bgm_volume, pitch :float = bgm_pitch):
	BGM_Player.set_stream(load(AU3ENGINE.table_save_path + AU3ENGINE.sfx_folder + bgm_stream))
	BGM_Player.set_volume_db(volume)
	BGM_Player.set_pitch_scale(pitch)
	BGM_Player.play()
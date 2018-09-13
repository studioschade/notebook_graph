extends Node

var notebook_scene = "res://scenes/tools/graph_panels/notebook_graphnode.tscn"
var terminal_scene = "res://scenes/tools/graph_panels/terminal_graphnode.tscn"
var table_scene = "res://scenes/tools/graph_panels/table_graphnode.tscn"

var RootNode
var SomeGraphEdit
var SomePopupMenu
var SomePopupMenuVisible = false
var RMBPressed = false

func load_scene(scene_filepath, custom_name = false, parent_nodepath = self.get_path()):
	if not scene_filepath:
		print("failed to load scene!")
		return
	var scene_reference = load(scene_filepath).instance()
	if custom_name:
		scene_reference.set_name(custom_name)
	get_node(parent_nodepath).add_child(scene_reference)
	scene_reference.raise()
	return scene_reference

func _menu_item_pressed(ID):
	print("Menu Item Pressed: ", SomePopupMenu.get_item_text(ID))
	if(SomePopupMenu.get_item_text(ID) == "Quit"):
		get_tree().quit()
	if(SomePopupMenu.get_item_text(ID) == "Add Notebook"):
		#var graphnode = generate_graphnode()
		var graphnode = load_scene(notebook_scene,"notebook_graphnode_", SomeGraphEdit.get_path())
	if(SomePopupMenu.get_item_text(ID) == "Add Table"):
		#var graphnode = generate_graphnode()
		var graphnode = load_scene(table_scene,"table_graphnode_", SomeGraphEdit.get_path())
	if(SomePopupMenu.get_item_text(ID) == "Add Terminal"):
		#var graphnode = generate_graphnode()
		var graphnode = load_scene(terminal_scene,"terminal_graphnode_", SomeGraphEdit.get_path())

func _node_connection_request(from, from_port, to, to_port):
	SomeGraphEdit.connect_node(from, from_port, to, to_port)

func _init():
	SomeGraphEdit = GraphEdit.new()
	SomeGraphEdit.set_name("SomeGraphEdit")
	SomeGraphEdit.set_anchor(MARGIN_RIGHT, SomeGraphEdit.ANCHOR_END, false)
	SomeGraphEdit.set_anchor(MARGIN_BOTTOM, SomeGraphEdit.ANCHOR_END, false)
	SomeGraphEdit.set_h_size_flags(3)
	SomeGraphEdit.set_v_size_flags(3)
	SomeGraphEdit.margin_top = 20
	SomeGraphEdit.margin_left = 20
	SomeGraphEdit.margin_right = -20
	SomeGraphEdit.margin_bottom = -20

	SomeGraphEdit.connect("raise_request", self, "_node_connection_request")
	SomeGraphEdit.connect("resize_request", self, "_node_connection_request")

	SomePopupMenu = PopupMenu.new()
	SomePopupMenu.set_name("SomePopupMenu")
	SomePopupMenu.add_item("New")
	SomePopupMenu.add_item("Load")
	SomePopupMenu.add_item("Save")
	SomePopupMenu.add_separator()
	SomePopupMenu.add_item("Add Notebook")
	SomePopupMenu.add_item("Add Terminal")
	SomePopupMenu.add_item("Add Table")
	SomePopupMenu.add_separator()
	SomePopupMenu.add_item("Simulate")
	SomePopupMenu.add_separator()
	SomePopupMenu.add_item("Quit")
	SomePopupMenu.connect("id_pressed", self, "_menu_item_pressed")
	SomeGraphEdit.add_child(SomePopupMenu)

func _ready():
	RootNode = get_node("/root/workspace/dynamic_plane")
	RootNode.add_child(SomeGraphEdit)
	SomeGraphEdit.set_theme(load("res://scenes/tools/graph_panels/terminal_theme.tres"))
	SomeGraphEdit.set_scroll_ofs(Vector2(-400, -230))

func _input(event):
	if(Input.is_action_pressed("ui_right_click")):
		SomePopupMenu.rect_position = get_viewport().get_mouse_position()
		SomePopupMenu.popup();


func generate_graphnode():
	var SomeGraphNode = GraphNode.new()
	SomeGraphNode.rect_position = get_viewport().get_mouse_position()
	SomeGraphNode.rect_min_size = Vector2(160, 120)
	SomeGraphNode.set_slot(0, true, 0, Color(0.0, 1.0, 1.0, 1.0), true, 0, Color(1.0, 0.0, 0.0, 1.0))
	SomeGraphNode.set_slot(1, false, 1, Color(1.0, 0.0, 1.0, 1.0), true, 2, Color(0.0, 1.0, 0.0, 1.0))
	SomeGraphNode.set_slot(2, true, 2, Color(1.0, 1.0, 0.0, 1.0), true, 1, Color(0.0, 0.0, 1.0, 1.0))
	var SomeLabel1 = Label.new()
	SomeLabel1.set_text("Slot 1")
	SomeGraphNode.add_child(SomeLabel1)
	var SomeLabel2 = Label.new()
	SomeLabel2.set_text("Slot 2")
	SomeGraphNode.add_child(SomeLabel2)
	var SomeLabel3 = Label.new()
	SomeLabel3.set_text("Slot 3")
	SomeGraphNode.add_child(SomeLabel3)
	SomeGraphNode.set_title("Node Title")
	SomeGraphEdit.add_child(SomeGraphNode)
	return SomeGraphNode
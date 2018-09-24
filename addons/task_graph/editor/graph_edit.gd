extends GraphEdit

const TaskGraphData = preload("res://addons/task_graph/task_graph_data.gd")
const TaskNode = preload("res://addons/task_graph/editor/task_node.tscn")
const InputNode = preload("res://addons/task_graph/editor/input_node.tscn")
const OutputNode = preload("res://addons/task_graph/editor/output_node.tscn")
const NotebookNode = preload("res://scenes/tools/graph_panels/notebook_graphnode.tscn")
#const TerminalNode = preload("res://scenes/tools/graph_panels/terminal_graphnode.tscn")
const TerminalNode = preload("res://scenes/tools/graph_panels/tasknode/terminal.tscn")

const TableNode = preload("res://scenes/tools/graph_panels/table_graphnode.tscn")

var resource

var selected_node
var place
var from
var from_slot

func _ready():
	set_process_unhandled_input(false)
	set_name("GraphEdit")
	set_anchor(MARGIN_RIGHT, ANCHOR_END, false)
	set_anchor(MARGIN_BOTTOM, ANCHOR_END, false)
	set_h_size_flags(3)
	set_v_size_flags(3)
	margin_top = 20
	margin_left = 20
	margin_right = -20
	margin_bottom = -20

	add_valid_connection_type(0, 0)
	#add_valid_left_disconnect_type(0)
	add_valid_right_disconnect_type(0)
	connect("node_selected", self, "selected")
	#connect("popup_request", self, "menu_requested")
	connect("connection_request", self, "connect_requested")
	connect("disconnection_request", self, "disconnect_requested")
	connect("connection_to_empty", self, "connect_empty_requested")

	#set_theme(load("res://scenes/tools/graph_panels/terminal_theme.tres"))
	$RightClickMenu.connect("index_pressed", self, "new_node_requested")
	$SaveDialog.connect("file_selected", self, "save_graph")
	$SaveDialog.add_filter("*." + TaskGraphData.EXTENSION + " ; Task Graph Data")
	$LoadDialog.connect("file_selected", self, "load_graph")
	$LoadDialog.add_filter("*." + TaskGraphData.EXTENSION + " ; Task Graph Data")
	$FileDialog.connect("file_selected", self, "file_selected")

	get_node("../Header/FileMenuButton").get_popup().connect("index_pressed", self, "file_option_selected")
	get_node("../Header/EditMenuButton").get_popup().connect("index_pressed", self, "edit_option_selected")

func _gui_input(event):
	#prints(event)
	if event.is_action_released("mouse_zoom_in"):
		accept_event()
	elif event.is_action_released("mouse_zoom_out"):
		accept_event()
	#else:
	#	set_mouse_filter(Control.MOUSE_FILTER_STOP)



func selected(node = selected_node):
	selected_node = node
	for child in get_children():
		if child is GraphNode: child.overlay = GraphNode.OVERLAY_DISABLED
	if node: highlight_dependencies(node)

func highlight_dependencies(node):
	var connections = get_connection_list()
	for connection in connections:
		if connection["to"] != node.name:
			continue
		var dependency = get_node(connection["from"])
		dependency.overlay = GraphNode.OVERLAY_POSITION
		highlight_dependencies(dependency)

func get_output_nodes(node):
	var output_nodes = []
	var all_connections = get_connection_list()
	for connection in all_connections:
		if connection["from"] == node.name:
			var temp_node = get_node(connection["to"])
			temp_node.overlay = GraphNode.OVERLAY_POSITION
			output_nodes.append(temp_node)
	prints(node.name, "has the following output nodes:", output_nodes)
	return output_nodes

func menu_requested(cursor):
	place = get_local_mouse_position() + Vector2(0,200)
	from = null
	from_slot = null
	$RightClickMenu.popup(Rect2(cursor, Vector2(1, 1)))

func file_option_selected(idx):
	if idx == 0:
		new_graph()
	elif idx == 1:
		save_requested()
	elif idx == 2:
		load_requested()

func edit_option_selected(idx):
	pass

func new_node_requested(node_type):
	# TODO Toggle comment property on nodes when they have dangling inputs as a sort of warning
	var node
	match(node_type):
		TaskGraphData.TASK_NODE:
			node = TaskNode.instance()
			node.set_meta("type", TaskGraphData.TASK_NODE)
		TaskGraphData.INPUT_NODE:
			node = InputNode.instance()
			node.set_meta("type", TaskGraphData.INPUT_NODE)
		TaskGraphData.OUTPUT_NODE:
			node = OutputNode.instance()
			node.set_meta("type", TaskGraphData.OUTPUT_NODE)
		TaskGraphData.NOTEBOOK_NODE:
			node = NotebookNode.instance()
			node.set_meta("type", TaskGraphData.NOTEBOOK_NODE)
			prints("Trying to make new notebook. " , TaskGraphData.NOTEBOOK_NODE)
		TaskGraphData.TERMINAL_NODE:
			node = TerminalNode.instance()
			node.set_meta("type", TaskGraphData.TERMINAL_NODE)
		TaskGraphData.TABLE_NODE:
			node = TableNode.instance()
			node.set_meta("type", TaskGraphData.TABLE_NODE)
		TaskGraphData.TASK_GRAPH_NODE:
			print("Can't make new GraphEdit, feature not implemented")
			return
		TaskGraphData.CONSTANT_NODE:
			print("Can't make new ConstantNode, feature not implemented")
			return
		_:
			return

	node.offset = place + scroll_offset
	add_child(node)

	if from and node_type == 2:
		connect_node(from, from_slot, node.name, 0)

func connect_requested(from, from_slot, to, to_slot):
	for connection in get_connection_list():
		if connection["to"] == to and connection["to_port"] == to_slot:
			disconnect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])
			break
	connect_node(from, from_slot, to, to_slot)
	#prints(get_connection_list())
	selected()

func disconnect_requested(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)
	selected()

func connect_empty_requested(p_from, p_from_slot, cursor):
	place = cursor
	from = p_from
	from_slot = p_from_slot
	$RightClickMenu.popup(Rect2(get_global_mouse_position(), Vector2(1, 1)))

func clear_node(node):
	for connection in get_connection_list():
		if connection["from"] == node.name or connection["to"] == node.name:
			disconnect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])
	selected()

func delete_node(node):
	clear_node(node)
	if selected_node == node: selected_node = null
	node.queue_free()

func clear_graph():
	clear_connections()
	for child in get_children():
		if child is GraphNode:
			child.queue_free()

func new_graph():
	clear_graph()
	resource = null

func save_requested():
	if not resource or resource.resource_path == "":
		$SaveDialog.popup_centered_ratio()
	else:
		save_graph()

func save_graph(file = null):
	if file:
		if not resource: resource = TaskGraphData.new()
		resource.take_over_path(file)
	var names = []
	var nodes = []
	for child in get_children():
		if child is GraphNode:
			nodes.append({
				"type": child.get_type(),
				"position": [child.offset.x, child.offset.y],
				"width": child.rect_size.x,
				"data": child.get_data(),
				#"inputs": child.get_inputs(),
				#"outputs": child.get_outputs(),
			})
			names.append(child.name)
	resource.nodes = nodes

	var connections = get_connection_list()
	for connection in connections:
		var from = get_node(connection["from"])
		var to = get_node(connection["to"])
		connection["from"] = names.find(connection["from"])
		connection["to"] = names.find(connection["to"])
		connection["from_port"] = from.get_output_from_index(connection["from_port"])
		connection["to_port"] = to.get_input_from_index(connection["to_port"])
	resource.connections = connections

	# TODO save graph offset too?

	ResourceSaver.save(resource.resource_path, resource)

func load_requested():
	$LoadDialog.popup_centered_ratio()

func load_graph(file):
	if typeof(file) == TYPE_STRING:
		resource = ResourceLoader.load(file)
	elif file is TaskGraphData:
		resource = file
	else:
		printerr("Unknown argument")
		return

	clear_graph()
	var nodes = []
	for node in resource.nodes:
		var graph_node
		if node["type"] == TaskGraphData.TASK_NODE:
			graph_node = TaskNode.instance()
		elif node["type"] == TaskGraphData.INPUT_NODE:
			graph_node = InputNode.instance()
		elif node["type"] == TaskGraphData.OUTPUT_NODE:
			graph_node = OutputNode.instance()
		else:
			pass
		add_child(graph_node)
		graph_node.offset = Vector2(node["position"][0], node["position"][1])
		graph_node.rect_size.x = node["width"]
		graph_node.set_data(node["data"])
		nodes.append(graph_node)

	for connection in resource.connections:
		var from = nodes[connection["from"]]
		var to = nodes[connection["to"]]
		connect_node(from.name, from.get_index_from_output(connection["from_port"]),
				to.name, to.get_index_from_input(connection["to_port"]))

var func_ref
func show_file_dialog(obj, func_name):
	func_ref = funcref(obj, func_name)
	$FileDialog.popup_centered_ratio()

func file_selected(file):
	func_ref.call_func(file)

func error(msg):
	$ErrorDialog.dialog_text = msg
	$ErrorDialog.popup_centered()

func _on_GraphEdit_mouse_entered():
	set_mouse_filter(Control.MOUSE_FILTER_IGNORE)

func _on_GraphEdit_mouse_exited():
	set_mouse_filter(Control.MOUSE_FILTER_IGNORE)

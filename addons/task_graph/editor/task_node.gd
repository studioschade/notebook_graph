extends GraphNode

const TaskGraphData = preload("res://addons/task_graph/task_graph_data.gd")
const GraphNodeRow = preload("res://addons/task_graph/editor/graph_node_row.tscn")

var task_class

var inputs
var outputs

func _ready():
	connect("close_request", get_parent(), "delete_node", [self])
	connect("resize_request", self, "resize_requested")

func choose_class():
	get_parent().show_file_dialog(self, "select_task_class")

func select_task_class(class_file):
	var check = load(class_file)
	if task_class == check: return
	# TODO Add option to disable these checks in File menu or File Dialog
	# TODO These checks won't work in other languages like C#
	if check == null:
		error("Error loading!")
		return
	if not check is Script:
		error("This is not a script!")
		return
	if not has_function(check, "_run"):
		error("This class doesn't have a '_run' method!\nRead the doc for more info...")
		return
	if not has_function(check, "_inputs", true):
		error("This class doesn't have an '_inputs' method!\nRead the doc for more info...")
		return
	if not has_function(check, "_outputs", true):
		error("This class doesn't have an '_outputs' method!\nRead the doc for more info...")
		return
	task_class = check
	update_node()

func update_node():
	get_parent().clear_node(self)
	clear_all_slots()
	for child in get_children():
		if child is HBoxContainer: child.free()

	$TaskFile.text = task_class.resource_path

	inputs = task_class._inputs()
	outputs = task_class._outputs()
	var amount = max(inputs.size(), outputs.size())

	var rows = []
	while amount > 0:
		rows.push_back(GraphNodeRow.instance())
		amount -= 1

	var i = 0
	for input in inputs:
		rows[i].get_node("LeftLabel").text = input
		i += 1

	while i < rows.size():
		rows[i].get_node("LeftLabel").visible = false
		i += 1

	i = 0
	for output in outputs:
		rows[i].get_node("RightLabel").text = output
		i += 1

	while i < rows.size():
		rows[i].get_node("RightLabel").visible = false
		i += 1

	for row in rows:
		add_child(row)
		set_slot(row.get_position_in_parent(), row.get_node("LeftLabel").visible, 0, Color(1, 1, 1),
				row.get_node("RightLabel").visible, 0, Color(1, 1, 1))

func error(msg):
	get_parent().error(msg)

#func has_function(script, func_name, is_static = false):
#	# TODO Replace with RegEx to parse out whitspaces and stuff
#	var has_static = script.source_code.find("static func " + func_name + "():") != -1
#	if is_static:
#		return has_static
#	else:
#		return script.source_code.find("func " + func_name + "():") != -1 and not has_static

func resize_requested(size):
	rect_size.x = size.x

func set_data(data):
	if not data: return
	task_class = load(data)
	update_node()

func get_data():
	return task_class.resource_path if task_class else null

func get_type():
	return TaskGraphData.TASK_NODE

func get_input_from_index(idx):
	return inputs[idx]

func get_output_from_index(idx):
	return outputs[idx]

func get_index_from_input(input):
	return inputs.find(input)

func get_index_from_output(output):
	return outputs.find(output)



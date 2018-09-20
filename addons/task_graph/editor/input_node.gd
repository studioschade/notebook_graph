extends GraphNode

const TaskGraphData = preload("res://addons/task_graph/task_graph_data.gd")

func _ready():
	connect("close_request", get_parent(), "delete_node", [self])
	connect("resize_request", self, "resize_requested")

func resize_requested(size):
	rect_size = size

func set_data(data):
	$InputName.text = data

func get_data():
	return $InputName.text

func get_type():
	return TaskGraphData.INPUT_NODE

# Input node doesn't have any inputs
#func get_input_from_index(idx):
#	pass

func get_output_from_index(idx):
	return $InputName.text

#func get_index_from_input(input):
#	pass

func get_index_from_output(output):
	return 0


extends GraphNode

const TaskGraphData = preload("res://addons/task_graph/task_graph_data.gd")

func _ready():
	connect("close_request", get_parent(), "delete_node", [self])
	connect("resize_request", self, "resize_requested")

func resize_requested(size):
	rect_size.x = size.x

func set_data(data):
	$OutputName.text = data

func get_data():
	return $OutputName.text

func get_type():
	return TaskGraphData.OUTPUT_NODE

func get_input_from_index(idx):
	return $OutputName.text

#func get_output_from_index(idx):
#	pass

func get_index_from_input(input):
	return 0

#func get_index_from_output(output):
#	pass
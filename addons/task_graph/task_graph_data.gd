extends Resource

enum Type{
	TASK_NODE
	INPUT_NODE
	OUTPUT_NODE
	NOTEBOOK_NODE
	TABLE_NODE
	TERMINAL_NODE
	TASK_GRAPH_NODE
	CONSTANT_NODE
}

const EXTENSION = "tres"

# TODO Change to storage nodes
# TODO Optimize data storage
#{
#	"name": String
#	"type": Type
#}
export var nodes = []

export var connections = []

func get_inputs():
	var inputs = []
	for node in nodes:
		if node["type"] == INPUT_NODE:
			inputs.push_back(node)
	return inputs

func get_outputs():
	var outputs = []
	for node in nodes:
		if node["type"] == OUTPUT_NODE:
			outputs.push_back(node)
	return outputs

func get_tasks():
	var tasks = []
	for node in nodes:
		if node["type"] == TASK_NODE:
			tasks.push_back(node)
	return tasks

# Instantiates all task classes
func load_tasks():
	var tasks = get_tasks()
	for idx in tasks.size():
		tasks[idx] = load(tasks[idx]["data"]).new()
	return tasks

# TODO Check if valid task graph (Useful for assertion)
func validate():
	pass

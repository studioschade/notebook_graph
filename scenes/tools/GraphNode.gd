extends GraphNode
"""
Author:Allen Schade
This is the generic graph_node object that all other graph_nodes build with.
Graph-nodes must all support the following methods
Input:
	* recieve between 0 and 2 inputs from another node
	* Send between 0 and 2 outputs to another node
	* Generate or process data from 1 attached script.
"""
enum {TERMINAL}

onready var task_graph = get_parent()

var task_node = null
var task_type = TERMINAL
var task_in_progress = false

var input = null
var input_node = null

onready var input_readout = get_node("panel/vbox/io/input/readout")
onready var output_readout = get_node("panel/vbox/io/output/readout")

var output = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if task_node:
		prints("A", name, "was created")
	else:
		prints("A graph node with no type was created!!!")

func set_input(value):
	input=value
	prints(name, "got a new input of type:", typeof(input))
	input_readout.set_text(String(input))
	#input_readout.hint_tooltip = String(input)

func set_output(value):
	output = value
	output_readout.set_text(String(output))
	transmit_output()

func transmit_output():
	var output_nodes
	if task_graph.has_method('get_output_nodes'):
		output_nodes = task_graph.get_output_nodes(self)
	if not output_nodes:
		prints(name,"has no output nodes to transmit to!")
		return
	for output_node in output_nodes:
		output_node.set_input(output)

func _on_GraphNode_resize_request(new_minsize):
	rect_min_size = new_minsize
	#$panel.rect_min_size = new_minsize - Vector2(20,20)
	#$panel.rect_size = $panel.rect_min_size
	rect_size = new_minsize
	#rect_position = get_parent().rect_position - Vector2(0,-20)

func _on_GraphNode_close_request():
	queue_free()

func _on_GraphNode_raise_request():
	raise()

func _on_value_text_entered(new_text):
	output = new_text
	transmit_output()

func _on_execute_pressed():
	if task_node:
		if task_node.has_method('execute'):
			prints("Trying to execute the ", task_node.name)
			set_output(task_node.execute())
	else:
		prints(self.name, "tried to execute its task, but it has no associated task node!!!")
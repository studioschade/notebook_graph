extends GraphNode
"""
This is the generic graph_node object that all other graph_nodes build with.
Graph-nodes must all support the following methods
Input:
	* recieve between 0 and 2 inputs from another node
	* Send between 0 and 2 outputs to another node
	* Generate or process data from 1 attached script.
"""
#All connections are two way and this node is responsible for type-checking
# and bounding of variables.

var input = null
var input_type = null
var input_node = null

var output = null
var output_type = null
var output_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	output = name

func set_input(value):
	prints(typeof(value))
	$basic_panel/io_panel/input_panel/value.text = String(value)

func set_output(value=null):
	output = value
	$basic_panel/io_panel/output_panel/value.text = String(value)
	transmit_output(output)

func transmit_output(destination_node = output_node):
	if not output_node:
		return
	if get_node("../" + output_node) and output:
		get_node("../" + output_node).set_input(output)

func _on_GraphNode_resize_request(new_minsize):
	rect_min_size = new_minsize
	#$panel.rect_min_size = new_minsize - Vector2(20,20)
	#$panel.rect_size = $panel.rect_min_size
	rect_size = new_minsize
	#rect_position = get_parent().rect_position - Vector2(0,-20)

func _on_GraphNode_close_request():
	queue_free()

func _on_GraphNode_raise_request():
	print("clicked")
	raise()

func _on_value_text_entered(new_text):
	output = new_text
	transmit_output()

func _on_execute_pressed():
	pass # Replace with function body.

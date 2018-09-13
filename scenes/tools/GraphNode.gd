extends GraphNode
"""
# GraphNotebook (Graphnode-based Jupyter notebook)

What?
GraphBook "Engines":
	 let designers write and execute code from ipython and 60+ popular programming languages via Jupyter inside Godot GraphNodes.
	* Each Jupyter notebook acts as an independent entity which may be connected to arbitrary graphnodes in a scene.
	* Network Graphbooks via the high level multiplayer API

GraphBook "Gasket":
	* They help developers ensure graphnodes from different languages or even over the network can communicate safely.
	* Gaskets can be applied to "Engines" to validate custom input/output schemes.
	* developer defined typechecking/contract/SLA systems for each connected node,
	stat collection and monitoring for violation contract violations
00
GraphBook "Tanks":
	These act as frontend and backend for a cusotmizeable queuing system.
	rate-limit and/or queuing of incoming or outgoing requests.

GraphBook Valves perform rate limiting.

Why Jupyter + Godot? The possibilites are endless. A few possibilities:
	* use Godot 2d/3d/VR engines for high-quality data visualizations.
	* in-game dynamic generation of text, image, audio and video content.
	* give godot access to all the visualization / scientific libraries for Jupyter.
	* create detailed live web-based dashboards for server monitoring and admin.
	* seamlessly pull data from a wide variety of sources into games/simulations.
	* generate, store, modify gameworlds both in-game and in-browser
	* load, view, edit godot savegames in Jupyter
	* building complex automated workflows with high levels of flexability and debugability.
	* design simulations in Jupyter and running them in Godot


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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
	$panel.rect_min_size = new_minsize - Vector2(20,20)
	$panel.rect_size = $panel.rect_min_size
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

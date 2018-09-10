extends GraphEdit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Graph Initialized")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	if to != from:
		connect_node(from,from_slot, to, to_slot )
		prints(from, to)
		get_node(from).output_node = to
		get_node(to).input_node = from
		#get_node(from).transmit_output()

func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	pass # Replace with function body.

func _on_GraphEdit_node_selected(node):
	set_selected(node)
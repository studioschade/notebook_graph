extends TextureRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum {SYSCALL,BASH,IPYTHON,JUPYTER}
export(int, "Task", "Input", "Output", "Notebook", "Table", "Terminal", "Task Graph", "Constant") var node_type = "Notebook"

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



var graphedit

# Called when the node enters the scene tree for the first time.
func _ready():
	var temp = get_tree().get_nodes_in_group("Graphedit")
	if temp:
		print("Found a graphedit")
		graphedit = temp[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_terminal_mouse_entered():
	self.set_self_modulate(Color("e5ff00"))

func _on_terminal_mouse_exited():
	self.set_self_modulate(Color("00ff04"))

func _on_terminal_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				self.set_self_modulate(Color("ff6c00"))
			else:
				if get_tree().get_nodes_in_group("Graphedit"):
					get_tree().get_nodes_in_group("Graphedit")[0].new_node_requested(node_type)
				else:
					print("Can't get requested node")
				self.set_self_modulate(Color("00ff04"))
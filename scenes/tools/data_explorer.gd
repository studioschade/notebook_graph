extends Tree

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var node = self

func _ready():
	node = get_parent()
	analyze_scene(get_parent())
	analyze_properties()

func _process(delta):
	pass
	analyze_properties()

func analyze_scene(parent_node):
	node = parent_node
	clear()
	var root = self.create_item()
	root.set_text(0, node.name)
	for child in node.get_children():
		if child != self:
			var child1 = self.create_item(root)
			child1.set_text(0, child.name)
			for sub_child in child.get_children():
				var subchild1 = self.create_item(child1)
				subchild1.set_text(0, sub_child.name)

func clone_me():
	var clone = self


func analyze_properties():
	self.clear()
	var root = self.create_item()
	root.set_text(0, node.name)
	for var_dict in node.get_property_list():
		var var_name = var_dict["name"]
		var value = node.get(var_name)
		if value:
			var tree_item = self.create_item(root)
			tree_item.set_text(0, var_name)
			tree_item.set_text(1, str(node.get(var_name)))
		#for value in variable:
		#	var subchild1 = self.create_item(root)
		#	subchild1.set_text(0, str(value))

#RECONNECT THIS SIGNAL
func _on_tree_visibility_changed():
	if visible:
		set_process(true)
		print("processing")
	else:
		set_process(false)

func _on_tree_item_activated():
	var selected_item = self.get_selected()
	if selected_item:
		var item_text = selected_item.get_text(0)
	#prints(self.get_selected().get_text(0))
	#analyze_properties()
	#for item in get_children():
	#	if item.activated:
	#		prints(item)
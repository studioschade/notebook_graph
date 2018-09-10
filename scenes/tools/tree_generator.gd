extends Tree

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var node = self
var root
func _ready():
	#node = get_tree().get_root()
	#analyze_children(get_tree().get_root())
	#analyze_properties()
	pass

func _process(delta):
	pass
	#analyze_properties(get_parent())

func analyze_children(parent_node):
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

func analyze_properties(node):
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

func analyze_notebook(notebook):
	self.clear()
	var root = self.create_item()
	root.set_text(0, "Notebook_Cell")
	#populate_tree(root,notebook)
	if "metadata" in notebook:
		var meta_tree = self.create_item(root)
		meta_tree.set_text(0, "metadata")
		for entry in notebook["metadata"]:
			var child = self.create_item(meta_tree)
			child.set_text(0, str(entry) + " : " + str(notebook["metadata"][entry]))

	if "cells" in notebook:
		var meta_tree = self.create_item(root)
		meta_tree.set_text(0, "cells")
		for entry in notebook["cells"]:
			var child = self.create_item(meta_tree)
			child.set_text(0, str(entry))

func generate_dict_tree(notebook):
	self.clear()
	var root = self.create_item(root)
	root.set_text(0, "Notebook_Cell")
	populate_tree(root, notebook)

func populate_tree(tree_root, notebook, key = null):
	for property in notebook:
		var branch = self.create_item()
		if key:
			branch.set_text(0, String(key))
		if typeof(notebook[property]) == TYPE_DICTIONARY:
			prints(property, "is a dictionary")
			if notebook[property].keys().size() == 1:
				print("Found a single keyval leaf " + String(notebook[property]))
				branch.set_text(0, String(name))
			elif notebook[property].size() > 1:
				print("Found a branch" + String(notebook[property]))
				populate_tree(property, notebook[property])
		else:
			print("Found a leaf node " + String(notebook[property]))
			branch.set_text(0, String(property))

	#for key in notebook:
	#	var tree_item = self.create_item(root)
	#	tree_item.set_text(0, key)
	#	tree_item.set_text(1, "Something")
		#for value in variable:
		#	var subchild1 = self.create_item(root)
		#	subchild1.set_text(0, str(value))


func clone_me():
	var clone = self

func _on_tree_visibility_changed():
	if visible:
		set_process(true)
		print("processing")
	else:
		set_process(false)

func _on_tree_item_activated():
	var selected_item = self.get_selected()
	var item_text = selected_item.get_text(0)
	#prints(self.get_selected().get_text(0))
	#analyze_properties()
	#for item in get_children():
	#	if item.activated:
	#		prints(item)
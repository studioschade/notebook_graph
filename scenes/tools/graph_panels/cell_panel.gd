extends TabContainer

enum {REQUEST_NOTEBOOK}
# String is a path to a file, custom filter provided as hint.
export(String, FILE, "*.ipynb") var default_notebook
var jupyter_path = "/home/shady/anaconda3/bin/jupyter-nbconvert"
#var notebook_path = "/home/shady/darknebulae_project/shadys_demos/godot_multiplayer_framework/jupyter/igraph.ipynb"
var notebook_path = "/home/shady/darknebulae_project/experimental/graphtool/GraphBookTemplate.ipynb"
var blocking = true
var notebook
var new_cell_path = "res://scenes/tools/graph_panels/notebook_cell.tscn"
var cell_manager_path = "Notebook/vbox/cells"
var focused_cell = 0

onready var current_cell_type_label = get_node("../menu/current_cell_type")
onready var current_cell_label = get_node("../menu/current_cell")



func _ready():
	delete_cells()
	#get_parent().get_parent().get_parent().popup()
	notebook = get_notebook(false)
	if notebook:
		populate_metadata(notebook)
		populate_cells(notebook)

func _on_execute_pressed():
	delete_cells()
	notebook = get_notebook(true)
	if notebook:
		populate_metadata(notebook)
		populate_cells(notebook)

func get_notebook(execute = false):
	#"--clear-output"
	var flags = ["--clear-output", notebook_path, "--stdout"]
	if execute:
		flags.push_front("--execute")
	var outputs = []
	var pid = OS.execute(jupyter_path, flags, blocking, outputs)
	var parsed_notebook = JSON.parse((outputs[0]))
	if typeof(parsed_notebook.result) == TYPE_DICTIONARY:
		return parsed_notebook.result
	else:
		print("response from kernel was not a properly formatted json file!!!")
		prints(outputs)
		return {}
		#/home/shady/anaconda3/bin/jupyter nbconvert --execute --clear-output /home/shady/darknebulae_project/shadys_demos/godot_multiplayer_framework/jupyter/igraph.ipynb --to results.ipynb --stdout

func _on_delete_cell():
	delete_cells()

#func _on_execute_cell():
#	notebook = get_notebook()

func delete_cells():
	for cell in get_node(cell_manager_path).get_children():
		cell.queue_free()

func _on_clear_cell():
	#clear OUTPUTS
	pass # Replace with function body.

func _on_cell_focus():
	pass # Replace with function body.


func _on_add_cell(): #This is signal from GUI
	add_cell() #Adds an empty cell

func add_cell(source_data = "", output_data ="", cell_type =""):
	if not new_cell_path:
		print("failed to find blank cell scene!")
		return
	var new_cell = load(new_cell_path).instance()
	new_cell.notebook = self
	#if cell_id:
	#	new_cell.set_name(String(cell_id))
	new_cell.set_type(cell_type)
	new_cell.set_source(source_data)
	new_cell.update_outputs(output_data)
	get_node(cell_manager_path).add_child(new_cell)
	new_cell.set_name(String(new_cell.get_index()))
	#new_cell.raise()
	return new_cell


func populate_cells(notebook):
	if "cells" in notebook:
		var cell_index
		var source_data = ""
		var output_data = ""
		var cell_type = "raw"
		for cell in notebook["cells"]:
			if "source" in cell:
				source_data = cell["source"]
			if "outputs" in cell:
				output_data = cell["outputs"]
			if "cell_type" in cell:
				cell_type = cell["cell_type"]
			#var source_data = String(notebook["cells"]["source"])
			var new_cell = add_cell(source_data, output_data, cell_type)

func populate_metadata(notebook):
	if "metadata" in notebook:
		for tag in notebook["metadata"]:
			#prints(notebook["metadata"][tag])
			prints("found a metadata")

extends MarginContainer

var notebook

func _on_execute_pressed():
	notebook = get_notebook()
	if notebook:
		#$cell/output.text = String(notebook)
		$cell/tree.analyze_notebook(notebook)
		#prints(notebook)

func get_notebook():
	var parsed_notebook = JSON.parse((execute_local_notebook()))
	if typeof(parsed_notebook.result) == TYPE_DICTIONARY:
		print(filename, " notebook_recieved!")
		return parsed_notebook.result
	else:
		print("response from kernel was not a properly formatted json file!!!")
		return {}


func execute_local_notebook():
	var jupyter_path = "/home/shady/anaconda3/bin/jupyter-nbconvert"
	#var notebook_path = "/home/shady/darknebulae_project/shadys_demos/godot_multiplayer_framework/jupyter/igraph.ipynb"
	var notebook_path = "/home/shady/darknebulae_project/experimental/graphtool/GraphBook.ipynb"
	var flags = ["--execute", "--clear-output", notebook_path, "--stdout"]
	var blocking = true # Block this thread on the return of the request

	var outputs = []
	var pid = OS.execute(jupyter_path, flags, blocking, outputs)
	return outputs[0]
	#/home/shady/anaconda3/bin/jupyter nbconvert --execute --clear-output /home/shady/darknebulae_project/shadys_demos/godot_multiplayer_framework/jupyter/igraph.ipynb --to results.ipynb --stdout

func _on_pick_notebook_path_button_up():
	pass # Replace with function body.

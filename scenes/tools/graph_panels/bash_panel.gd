extends VBoxContainer
var notebook

var result

func _on_Button_pressed():
	#$HTTPRequest.request("http://127.0.0.1:8888",[],false)
	#$HTTPRequest.request(url, headers, false, HTTPClient.METHOD_GET)
	#notebook = execute_local_notebook()
	notebook = get_notebook()
	if notebook:
		prints(notebook)

func get_notebook():
	var parsed_notebook = JSON.parse((execute_command()))
	if typeof(parsed_notebook.result) == TYPE_DICTIONARY:
		return parsed_notebook.result
	else:
		print("response from kernel was not a properly formatted json file!!!")
		return {}


func execute_command(command = "ls"):
	var jupyter_path = "/home/shady/anaconda3/bin/jupyter-nbconvert"
	var notebook_path = "/home/shady/darknebulae_project/shadys_demos/godot_multiplayer_framework/jupyter/igraph.ipynb"
	var flags = ["--execute", "--clear-output", notebook_path, "--stdout"]
	var blocking = true # Block this thread on the return of the request

	var outputs = []
	var pid = OS.execute(jupyter_path, flags, blocking, outputs)
	return outputs[0]
	#/home/shady/anaconda3/bin/jupyter nbconvert --execute --clear-output /home/shady/darknebulae_project/shadys_demos/godot_multiplayer_framework/jupyter/igraph.ipynb --to results.ipynb --stdout

func _on_command_text_text_entered(new_text):
	result = execute_command(new_text)
	#$output.set_text(String(result))
	get_parent().set_output(result)

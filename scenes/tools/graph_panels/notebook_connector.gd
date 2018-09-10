extends CanvasLayer

func _ready():
	#$HTTPRequest.connect_to_host("http://127.0.0.1", 52553, false, false )
	pass

var headers = ["Content-Type: application/json"]
var url = "http://127.0.0.1:8888"

var notebook

func _on_Button_pressed():
	#$HTTPRequest.request("http://127.0.0.1:8888",[],false)
	#$HTTPRequest.request(url, headers, false, HTTPClient.METHOD_GET)
	#notebook = execute_local_notebook()
	notebook = load_notebook()
	execute_command()

	if notebook:
		prints(notebook)

func load_notebook():
	var parsed_notebook = JSON.parse((execute_command()))
	if typeof(parsed_notebook.result) == TYPE_DICTIONARY:
		print(filename, " notebook_recieved!")
		return parsed_notebook.result
	else:
		print("response from kernel was not a properly formatted json file!!!")
		return {}

func execute_command():
	var jupyter_path = "/home/shady/anaconda3/bin/jupyter-nbconvert"
	var notebook_path = "/home/shady/darknebulae_project/shadys_demos/godot_multiplayer_framework/jupyter/igraph.ipynb"
	var flags = ["--execute", "--clear-output", notebook_path, "--stdout"]
	var blocking = true # Block this thread on the return of the request

	var outputs = []
	var pid = OS.execute(jupyter_path, flags, blocking, outputs)
	return outputs[0]
	#/home/shady/anaconda3/bin/jupyter nbconvert --execute --clear-output /home/shady/darknebulae_project/shadys_demos/godot_multiplayer_framework/jupyter/igraph.ipynb --to results.ipynb --stdout

var command = "ls"
var result


func _on_command_text_text_entered(new_text):
	result = execute_command(new_text)
	$output.set_text(String(result))
	get_parent().set_output(result)


func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	prints("Got response from kernel:",result, response_code,headers)
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)

func _make_post_request(url, data_to_send, use_ssl):
	# Convert data to json string:
	var query = JSON.print(data_to_send)
	$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)

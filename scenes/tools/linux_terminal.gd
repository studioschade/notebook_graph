extends Control

enum {TERMINAL}
var task_type = TERMINAL

##"r'(\x9B|\x1B\[)[0-?]*[ -/]*[@-~]'"


enum {SH,BASH,IPYTHON,JUPYTER}
export var user_shell = IPYTHON

# Example:" shell[BASH][FLAGS] =
var shell= {
	SH: {
		"path": null,
		"flags": []},
	BASH: {
		"path":"/bin/bash",
		"flags": ["-c"]},
	IPYTHON: {
		"path": "/home/shady/.local/bin/ipython3",
		#"path": "ipython3",
		"flags": [
			"--no-confirm-exit",
			#"--automagic",
			#"--debug",
			"--pdb",
			#"--no-pprint",
			#"--simple-prompt",
			#"--no-color-info",
			#"--quiet",
			"--no-term-title",
			#"--profile-dir=./.ipython",
			"--profile=taskgraph",
			#"--TerminalInteractiveShell.display_page=True",
			"-c"]
		},
	JUPYTER: {
		"path": null,
		"flags": []}
		}

var title = "Command Terminal"
var last_command = ''
var last_output = ''
var command_output = []
var pid

#This variable is set with the last input from a taskgraph node
var input setget set_input, get_input
var output setget set_output, get_output

func _ready():
	set_process_input(false)
	if "task_node" in get_parent():
		get_parent().task_node = self
	else:
		prints("Uh oh",name, " isn't supposed to manage tasks!!!")

func get_input():
	return input

func get_output():
	return output

func set_input(new_input):
	if not new_input:
		print("Got a null value!!")
		return
	if new_input == "":
		return
	input=new_input

func set_output(new_value):
	output = new_value
	if get_parent().has_method('set_output'):
		get_parent().set_output(output)
	else:
		print("OOPS! Parent node has no set_output method!!!")

func run_command(command):
	var command_result
	match(user_shell):
		SH:
			command_result = run_shell_command(command)
		IPYTHON:
			command_result = run_ipython_command(command)
		JUPYTER:
			command_result = run_jupyter_cell(command)
	if command_result:
		evaluate_command_result(command_result)

func run_shell_command(user_input):
	var command
	var flags
	if " " in user_input:
		flags = user_input.split(" ")
	else:
		flags = PoolStringArray([])
	if flags.size()<2:
		pid = OS.execute(user_input, flags , true, command_output)
	else:
		command = flags.pop_front()
		pid = OS.execute(command, flags , true, command_output)
	return command_output[0]

# Format the commands what the users shell.
func run_ipython_command(user_input):
	var shell_path = shell[user_shell]["path"]
	var flags = shell[user_shell]["flags"].duplicate()
	user_input = "\'{input}\'".format({'input': user_input})
	flags.append(user_input)
	pid = OS.execute(shell_path, flags , true, command_output)
	return command_output[0]

func run_jupyter_cell(user_input):
	return $python.execute_command(user_input)

func run_command_old(user_command, user_flags=[""], shell_path = null, shell_flags = []):
	#pid = OS.execute('ls', ['-l', '/tmp'], true, output)
	if not shell[user_shell]["path"]: #Run as system call (NO ERROR CHECKING, RISKY)
		pid = OS.execute(user_command, user_flags, true, command_output)
	else:
		var full_options = shell_flags + Array(user_flags)
		full_options.push_back(user_command)
		pid = OS.execute(shell_path, full_options, true, command_output)
		prints("full options", full_options)
	return command_output[0]

func _gui_input(event):
	if event.is_action_released("mouse_zoom_in"):
		accept_event()
	elif event.is_action_released("mouse_zoom_out"):
		accept_event()
	accept_event()

func _on_type_item_selected(ID):
	ID = int(ID)
	user_shell = ID
	match(ID):
		SH:
			add_item_to_terminal("Switched to basic POSIX shell. ex: sh -c 'user input'")
		IPYTHON:
			add_item_to_terminal("Switched to Ipython shell by doing system calls. ex: ipython -c 'user input'")
		JUPYTER:
			add_item_to_terminal("Switched to native Jupyter shell using Godot-Python")


func evaluate_command_result(terminal_result):
	add_item_to_terminal("$ " + last_command + "\n")
	match typeof(terminal_result):
		TYPE_ARRAY:
			prints("result was an array", terminal_result)
			for result in terminal_result:
				add_item_to_terminal(result)
		TYPE_STRING:
			add_item_to_terminal(terminal_result)
		TYPE_DICTIONARY:
			prints("result was a dictionary", terminal_result)
			for entry in terminal_result:
				add_item_to_terminal(terminal_result[entry])
		_:
			add_item_to_terminal("Got a unknown result type!!!")
			prints("Got an unknown output", terminal_result)
			return
	set_output(terminal_result)

func add_item_to_terminal(console_text):
	var pre = "[color=lime]"
	var post = "[/color]"
	prints(console_text)
	var terminal_string = "{output}".format({'output':String(console_text)})
	$vbox/margin/output.set_bbcode($vbox/margin/output.get_bbcode() + pre + terminal_string + post + "\n")
	#$vbox/margin/output.set_text($vbox/margin/output.get_text() + String(console_text))

### Input Prompt Stuff ###
func _on_prompt_text_entered(command):
	if command:
		run_command(command)
		$vbox/prompt.clear()

func _on_prompt_gui_input(event):
	if event is InputEventKey:
		if event.scancode == KEY_UP:
			$vbox/prompt.text = last_command
			$vbox/prompt.grab_focus()
### Input Prompt Stuff ###

func _on_input_focus_entered():
	set_process_input(true)
	set_process_unhandled_key_input(false)

func _on_input_focus_exited():
	set_process_input(false)
	set_process_unhandled_key_input(true)

func _on_graphnode_mouse_entered():
	pass # Replace with function body.

func _on_graphnode_mouse_exited():
	pass # Replace with function body.

#func find_command_in_path(command_name):
#	for command in path:
#		var binary = File.new()
#	if binary.file_exists.open("/bin/ls"):
#			file_exists

#func command_exists(path, file_name):
#	var dir = Directory.new()
#	if dir.open(path + filename) == OK:
#		print(program exists in
#		return true
#	else:
#		print("An invalid directory is in the path.")


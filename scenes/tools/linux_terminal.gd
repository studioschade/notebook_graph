extends Control

enum {TERMINAL}
var task_type = TERMINAL




enum {SYSCALL,BASH,IPYTHON,JUPYTER}
export var user_shell = JUPYTER

# Example:" shell[BASH][FLAGS] =
var shell= {
	SYSCALL: {
		"path": null,
		"flags": []},
	BASH: {
		"path":"/bin/bash",
		"flags": ["-c"]},
	IPYTHON: {
		"path": "ipython3",
		#"path": "/home/shady/anaconda3/bin/ipython3",
		"flags": [
			"--no-confirm-exit",
			#"--automagic",
			"--no-pdb",
			"--no-pprint",
			"--simple-prompt",
			"--no-color-info",
			#"--quiet",
			"--no-term-title",
			#"--profile-dir=./.ipython",
			"--TerminalInteractiveShell.display_page=True"]},
	JUPYTER: {
		"path": null,
		"flags": []}
		}


var title = "Command Terminal"
var last_input = ''
var last_output = ''

var command_output = []
var pid
#This variable is set with the last input from a taskgraph node
var input setget set_input, get_input
var output setget set_output, get_output

func _ready():
	set_process_input(false)
	#set_process_unhandled_key_input(true)
	if "task_node" in get_parent():
		get_parent().task_node = self
	else:
		prints("Uh oh",name, " isn't supposed to manage tasks!!!")

func get_input():
	return input

func set_input(new_input):
	if not new_input:
		print("Got a null value!!")
		return
	input = new_input
	if input != "":
		var terminal_result = execute_task(input)
		last_input = input
		if typeof(terminal_result) == TYPE_ARRAY:
			prints("result was an array", terminal_result)
			for result in terminal_result:
				prints(name,' ', result)
				#add_item_to_chat(result)
			set_output(terminal_result)
		elif typeof(terminal_result) == TYPE_STRING:
			set_output(terminal_result)
		elif typeof(terminal_result) == TYPE_DICTIONARY:
			prints("result was a dictionary", terminal_result)
			for entry in terminal_result:
				set_output(str(entry))
		else:
			prints("Got a weird output",terminal_result)

func set_output(new_value):
	output = new_value
	if get_parent().has_method('set_output'):
		get_parent().set_output(output)
	else:
		print("OOPS! Parent node has no set_output method!!!")
	prints("output type is" , typeof(new_value))
	add_item_to_terminal("$ " + input)
	add_item_to_terminal(output)

func get_output():
	return output

func execute_task(user_input):
	if not user_input:
		print("Invalid command entered!")
		return false
	var user_flags = user_input.split(" ")
	var user_command = '-c ' + user_input
	#var user_command = '-c !' + user_input
	user_flags.remove(0)
	#print("user command", user_command)
	var shell_path = shell[user_shell]["path"]
	var shell_flags = []
	#if not shell[user_shell]["flags"].empty():
	shell_flags = shell[user_shell]["flags"]
	if user_shell == JUPYTER:
		return $python.execute_command(user_input)
	else:
		return run_command(user_command, user_flags, shell_path, shell_flags)

func run_command(user_command, user_flags=[""], shell_path = null, shell_flags = []):
	#pid = OS.execute('ls', ['-l', '/tmp'], true, output)
	if not shell[user_shell]["path"]: #Run as system call (NO ERROR CHECKING, RISKY)
		pid = OS.execute(user_command, user_flags, true, command_output)
	else:
		var full_options = shell_flags + Array(user_flags)
		full_options.push_back(user_command)
		pid = OS.execute(shell_path, full_options, true, command_output)
		prints("full options", full_options)
	return command_output[0]


##### UX Stuff ######

func add_item_to_terminal(console_text):
	var pre = "[color=lime]"
	var post = "[/color]"
	prints(console_text)
	$vbox/margin/output.set_bbcode($vbox/margin/output.get_bbcode() + pre + console_text + post + "\n")
	#$vbox/margin/output.set_text($vbox/margin/output.get_text() + pre + String(console_text) + post + "\n")

func _on_input_text_entered(text):
	if text:
		set_input(text)
	$vbox/input.clear()

func _on_input_focus_entered():
	set_process_input(true)
	set_process_unhandled_key_input(false)

func _on_input_focus_exited():
	set_process_input(false)
	set_process_unhandled_key_input(true)

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

func _on_input_gui_input(event):
	if event is InputEventKey:
		if event.scancode == KEY_UP:
			$vbox/input.text = last_input
			$vbox/input.grab_focus()


func _gui_input(event):
	#prints(event)
	if event.is_action_released("mouse_zoom_in"):
		#print("zoom graphnode")
		accept_event()
	elif event.is_action_released("mouse_zoom_out"):
		#print("zoom graphnode")
		accept_event()
	accept_event()

func _on_graphnode_mouse_entered():
	pass # Replace with function body.

func _on_graphnode_mouse_exited():
	pass # Replace with function body.


func _on_type_item_selected(ID):
	ID = int(ID)
	user_shell = ID
	match(ID):
		BASH:
			add_item_to_terminal("Switched to Bash shell by doing system calls. ex: bash -c 'user input'")
		IPYTHON:
			add_item_to_terminal("Switched to Ipython shell by doing system calls. ex: ipython -c 'user input'")
		JUPYTER:
			add_item_to_terminal("Switched to native Jupyter shell using Godot-Python")

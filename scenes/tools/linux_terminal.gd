extends Control

const SMALL_CHAT_SIZE = Vector2(480,104)
const SMALL_CHAT_POSITION = Vector2(-20,132)
const LARGE_CHAT_SIZE = Vector2(480,237)
const LARGE_CHAT_POSITION = Vector2(-20,-21)
const SMALL_LCD_SIZE = Vector2(1262,305)
const SMALL_LCD_POSITION = Vector2(-31,122)
const LARGE_LCD_SIZE = Vector2(1262,696)
const LARGE_LCD_POSITION = Vector2(-31,-35)

var path
var is_chatting = false

func _ready():
	set_process_input(false)
	set_process_unhandled_key_input(true)

	#path = execute_command("/bin/echo $PATH").split(",")
	#add_item_to_chat(str(path))

var command_history = ['What? you think should have command history?"']
var history_position = 0

#func _gui_input(event):

func _on_input_gui_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_UP:
			$input.text = String(command_history[0])

#	print(str(event))
#	print("Oh yeah looking")
#	if event.is_action_pressed("open_chat"):
#		if is_chatting == false:
#			$input.grab_focus()
#			print("grabbed focus")

func _on_input_text_entered(text):
	if text != "":
		#prints(text)
		var terminal_result = execute_command(text)
		if typeof(terminal_result) == TYPE_ARRAY:
			for result in terminal_result:
				add_item_to_chat(result)

	$input.clear()
	$input.release_focus()

func execute_command(command = ""):
	if not command:
		print("Invalid command entered!")
		return false
	else:
		command_history.append(command)
	var flags = command.split(" ")
	command = flags[0]
	flags.remove(0)
	#inputs.insert(0, "-c")
	var output = []
	var pid = OS.execute(command, flags, true, output)
	#var pid = OS.execute("/bin/bash", inputs, true, output)
	#var pid = OS.execute('ls', ['-l', '/tmp'], true, output)
	#prints(output)
	return output

#func find_command_in_path(command_name):
#	for command in path:
#		var binary = File.new()
#	if binary.file_exists.open("/bin/ls"):
#			file_exists

func add_item_to_chat(console_text):
	var pre = "[color=lime]"
	var post = "[/color]"
	$output.set_bbcode($output.get_bbcode() + pre + console_text + post + "\n")


#func command_exists(path, file_name):
#	var dir = Directory.new()
#	if dir.open(path + filename) == OK:
#		print(program exists in
#		return true
#	else:
#		print("An invalid directory is in the path.")

func _on_input_focus_entered():
	# The text window grows and the scrolls bar goes away when we are typing text
	is_chatting=true
	#print("focus entered")
	#$output.set_size(LARGE_CHAT_SIZE)
	#$output.set_position(LARGE_CHAT_POSITION)
	#$output_frame.set_size(LARGE_LCD_SIZE)
	#$output_frame.set_position(LARGE_LCD_POSITION)
	#$output.set_scroll_active(true)
#	set_process_input(true)
#	set_process_unhandled_key_input(false)

func _on_input_focus_exited():
	# After we enter text the text window shrinks and the scrolls bar goes away
	#print("focus exited")
	#$output_frame.set_size(SMALL_LCD_SIZE)
	#$output_frame.set_position(SMALL_LCD_POSITION)
	#$output.set_size(SMALL_CHAT_SIZE)
	#$output.set_position(SMALL_CHAT_POSITION)
	#output.set_scroll_active(false)
	#set_process_input(false)
#	set_process_unhandled_key_input(true)
	is_chatting = false


func _on_terminal_mouse_exited():
	pass # Replace with function body.


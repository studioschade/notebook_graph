extends Control

export(NodePath) var screen_1
export(NodePath) var screen_2
export(NodePath) var screen_3

onready var screens = [null, screen_1, screen_2, screen_3]
var button_name = "Settings"
var active_screen = null
var active_node = null
var hide_on_close = false

var node_name

func _ready():
	if screen_1:
		$gui_elements/button_1/label.text = get_node(screens[1]).name
	if screen_2:
		$gui_elements/button_2/label.text = get_node(screens[2]).name
	if screen_3:
		$gui_elements/button_3/label.text = get_node(screens[3]).name

func select_screen(screen_id = null):
	#Panel needs to be opened
	if screen_id == null:
		if active_screen == null:
			screen_id = 1
		else:
			screen_id = active_screen
	if active_screen == null:
		node_name = "gui_elements/button_" + str(screen_id) + "/label"
		get_node(node_name).set_modulate(Color("ffe32d"))
		$animator.play("open")
		$gui_elements/expand_audio.play()
		active_screen = screen_id
		active_node = get_node(screens[screen_id])
	#Panel needs to be closed
	elif active_screen == screen_id:
		$gui_elements/shrink_audio.play()
		node_name = "gui_elements/button_" + str(screen_id) + "/label"
		get_node(node_name).set_modulate(Color("ffffff"))
		$animator.play_backwards("open")
		active_screen = null
		if active_node:
			active_node.hide()
			active_node = null
	#Panel is open but changing screens
	else:
		var node_name = "gui_elements/button_" + str(active_screen) + "/label"
		get_node(node_name).set_modulate(Color("ffffff"))
		$gui_elements/expand_audio.play()

		if active_node:
			active_node.hide()
			active_node = null
		$animator.play("change_screen")

		active_screen = screen_id
		active_node = get_node(screens[screen_id])
		node_name = "gui_elements/button_" + str(screen_id) + "/label"
		get_node(node_name).set_modulate(Color("ffe32d"))

func _on_button_1_pressed():
	select_screen(1)

func _on_button_2_pressed():
	select_screen(2)

func _on_button_3_pressed():
	select_screen(3)

func _on_button_1_mouse_entered():
	if active_screen == 1:
		$gui_elements/button_1/label.set_modulate(Color("ff3f3a"))
	else:
		$gui_elements/button_1/label.set_modulate(Color("54ff40"))

func _on_button_1_mouse_exited():
	if active_screen == 1:
		$gui_elements/button_1/label.set_modulate(Color("ffe32d"))
	else:
		$gui_elements/button_1/label.set_modulate(Color("ffffff"))

func _on_button_2_mouse_entered():
	if active_screen == 2:
		$gui_elements/button_2/label.set_modulate(Color("ff3f3a"))
	else:
		$gui_elements/button_2/label.set_modulate(Color("54ff40"))

func _on_button_2_mouse_exited():
	if active_screen == 2:
		$gui_elements/button_2/label.set_modulate(Color("ffe32d"))
	else:
		$gui_elements/button_2/label.set_modulate(Color("ffffff"))

func _on_button_3_mouse_entered():
	if active_screen == 3:
		$gui_elements/button_3/label.set_modulate(Color("ff3f3a"))
	else:
		$gui_elements/button_3/label.set_modulate(Color("54ff40"))

func _on_button_3_mouse_exited():
	if active_screen == 3:
		$gui_elements/button_3/label.set_modulate(Color("ffe32d"))
	else:
		$gui_elements/button_3/label.set_modulate(Color("ffffff"))

func _on_animator_animation_finished(anim_name):
	if hide_on_close:
		hide()

	if anim_name == "open":
		if active_node:
			active_node.show()
	elif anim_name == "change_screen":
		if active_node:
			active_node.show()



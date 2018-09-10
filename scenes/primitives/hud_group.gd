extends Panel
# This is a custom GUI component that enabled more customized tabs

# This determines if the panel is at the top of the screen or bottom
export var top_aligned = true

onready var button_1 = get_node("button_1")
onready var button_2 = get_node("button_2")
onready var button_3 = get_node("button_3")
onready var animate_up = get_node("animate_up")
onready var animate_down = get_node("animate_down")
onready var tabs = get_node("tabs")

var pending_open = false
var currently_open = true

func _ready():
	close_panel()

func close_panel():
	if currently_open:
		if top_aligned:
			animate_up.play("move_panel_up")
		else:
			animate_down.play("move_panel_down")
	currently_open = false

func open_panel():
	pending_open = false
	currently_open = true
	if button_1.is_pressed ():
		tabs.set_current_tab(0)
	if button_2.is_pressed ():
		tabs.set_current_tab(1)
	if button_3.is_pressed ():
		tabs.set_current_tab(2)
	if top_aligned:
		animate_down.play("move_panel_down")
	else:
		animate_up.play("move_panel_up")

func _on_button_1_toggled( pressed ):
	if pressed:
		button_2.set_pressed(false)
		button_3.set_pressed(false)
		pending_open = true
	else:
		pending_open = false
	if not currently_open:
		open_panel()
	else:
		close_panel()

func _on_button_2_toggled( pressed ):
	if pressed:
		button_1.set_pressed(false)
		button_3.set_pressed(false)
		pending_open = true
	else:
		pending_open = false
	if not currently_open:
		open_panel()
	else:
		close_panel()

func _on_button_3_toggled( pressed ):
	if pressed:
		button_1.set_pressed(false)
		button_2.set_pressed(false)
		pending_open = true
	else:
		pending_open = false
	if not currently_open:
		open_panel()
	else:
		close_panel()

func _on_animate_up_animation_finished( animation_name ):
	if pending_open:
		open_panel()

func _on_animate_down_animation_finished( animation_name ):
	if pending_open:
		open_panel()

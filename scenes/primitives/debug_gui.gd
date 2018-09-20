extends PanelContainer

enum {VISUAL,SYMBOLIC}
var view_modes = {
	VISUAL: Vector2(150,130),
	SYMBOLIC: Vector2(600,400),
}
var view

var drag_start
#var lobby_scene = load("res://lobby.tscn")
onready var button_overlay = get_node("button_overlay")
onready var frame = get_parent()

var window
export var fade_time = .25

func _ready():
	window = get_parent()

#func _input(event):
#	if Input.is_action_just_pressed("ui_cancel"):
#		toggle_window()
	#drag_window(event)

func _process(delta):
	if not visible:
		set_process(false)
	if drag_start:
		#frame.set_self_modulate("8bff00")
		button_overlay.set_self_modulate("8bff00")
	else:
		set_process(false)

func toggle_view():
	if view == SYMBOLIC:
		view = VISUAL
	else:
		view = SYMBOLIC

	if not $tween.is_active():
		$tween.interpolate_property(window, "rect_size",  window.rect_size, view_modes[view], fade_time, Tween.TRANS_BOUNCE , Tween.EASE_IN_OUT)
		$tween.interpolate_property(window, "rect_min_size",  window.rect_min_size, view_modes[view], fade_time, Tween.TRANS_BOUNCE , Tween.EASE_IN_OUT)
		$tween.start()
		$tween.set_active(true)
	#window.rect_min_size = view_modes[view]
	#window.rect_size = view_modes[view]

func toggle_window():
	if window.visible:
		show_window(false)
	else:
		show_window(true)

func drag_window(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.doubleclick:
				toggle_view()
			if event.pressed:
				drag_start = true
				$button_overlay.set_modulate("8bff00")
			else:
				drag_start = false

	elif event is InputEventMouseMotion:
		if drag_start:
			#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
			$button_overlay.set_modulate(Color("a7ff91"))
			var new_pos = get_global_mouse_position()
			new_pos.x -= frame.rect_size.x / 2
			new_pos.y -= 20
			#new_pos.x -= get_parent().rect_size.x
			var new_rect=Rect2(new_pos, frame.rect_size)
			#This nicely checks if the rect is in the viewport, but odnt need it.
			if get_viewport_rect().encloses(new_rect):
				get_parent().rect_global_position = new_pos
				#get_parent().rect_global_position = get_global_mouse_position() - (get_parent().rect_size / 2)
		else:
			$button_overlay.set_modulate(Color("a2ff8b"))
			#	drag_start = false
			#Vector2(265,15)#update()

func _on_close_button_gui_input(event):
	if event is InputEventMouseButton:
		set_process(true)
		if event.button_index == 1:
			if event.pressed:
				toggle_window()


func show_window(window_on):
	var end_value
	var start_value = Color(1, 1, 1, window.modulate.a)
	if window_on:
		window.show()
		end_value = Color(1, 1, 1, 1)
	else:
		end_value = Color(1, 1, 1, 0)
	if not $tween.is_active():
		$tween.interpolate_property(window, "modulate",  start_value, end_value, fade_time, Tween.TRANS_BOUNCE , Tween.EASE_IN_OUT)
		$tween.start()
		$tween.set_active(true)

func _on_tween_completed(object,key):
	print("All done")
	#if not window.visible: #Window is already transarent, now fully hide it.
	if window.modulate == Color(1, 1, 1, 0):
		window.hide()
	$tween.set_active(false)
	$tween.stop_all()

func _on_drag_bar_gui_input(event):
	drag_window(event)
	get_parent().raise()

func _on_resize_button_gui_input(event):
	if event is InputEventMouseMotion and event.button_mask&1:
		frame.rect_size = get_parent().rect_global_position + get_global_mouse_position()

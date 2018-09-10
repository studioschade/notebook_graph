
extends MarginContainer

func _on_drag_gui_input(event):
	if event is InputEventMouseMotion and event.button_mask&1:
		var rel_position = event.relative
		#if ClassDB.is_parent_class( get_parent().get_class(), "Node2D"):
		#	global_position = get_global_mouse_position() + rel_position
		#elif ClassDB.is_parent_class( get_parent().get_class(), "Control"):
		rect_global_position = get_global_mouse_position() + rel_position

func _on_resize_gui_input(event):
	if event is InputEventMouseMotion and event.button_mask&1:
		var rel_position = event.relative
		#if ClassDB.is_parent_class( get_parent().get_class(), "Node2D"):
		#	get_parent().global_position = get_global_mouse_position() + rel_position
		if ClassDB.is_parent_class( get_parent().get_class(), "Control"):

			#$resize.global_rect_position = get_global_mouse_position() #+ rel_position
			rect_size = event.relative


func get_base_class(object):
	if ClassDB.is_parent_class( object.get_class(), "Node2D"):
		return "Node2D"
	elif ClassDB.is_parent_class( object.get_class(), "Control"):
		return "Control"
	else:
		return null

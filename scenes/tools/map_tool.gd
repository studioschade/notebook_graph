extends Node2D
const NODE_COLOR = Color(0.8,0.1,0.7,1)
const CONNECTION_COLOR = Color(1.0,0.1,1.0,0.5)
const GRID_COLOR = Color(0.1,0.9,0.5,0.5)
onready var start_node = get_node("start")
onready var end_node = get_node("end")
export(float) var connection_width = 2
export(float) var grid_width = 1
export var grid_spacing = 50


var drag_start = false
var drag_end = false
#export(Vector2) var start = Vector2(0,0) setget set_start
#export(Vector2) var end = Vector2(0,0) setget set_end

func _draw():
	draw_grid()
	#scroll_lines()
	draw_line($start.position, $end.position, CONNECTION_COLOR, connection_width, true)
	draw_circle($start.position, 23, NODE_COLOR)
	draw_circle($end.position, 23, NODE_COLOR)

func _process(delta):
	update()
	#$start.position = $ship_base.position#.snapped(Vector2(50,50))


var delta = 0


func make_grid(grid_position, grid_spacing, total_rows, total_columns):
	var x_end = 25
	var y_end = -1250
	var column = 1
	while column < total_columns:
		draw_line(position + (grid_spacing * column), Vector2(x_end, 725), GRID_COLOR, grid_width, true)
	while x_end < 725:
		draw_line(Vector2(x_end,25), Vector2(x_end, 725), GRID_COLOR, grid_width, true)
		x_end += grid_spacing

	while y_end < 1950:
		draw_line(Vector2(25, y_end), Vector2(725, y_end), GRID_COLOR, grid_width, true)
		y_end += grid_spacing

func draw_grid():
	var x_end = 25
	while x_end < 725:
		draw_line(Vector2(x_end,25), Vector2(x_end, 725), GRID_COLOR, grid_width, true)
		x_end += grid_spacing
	var y_end = -1250
	while y_end < 1950:
		draw_line(Vector2(25, y_end), Vector2(725, y_end), GRID_COLOR, grid_width, true)
		y_end += grid_spacing


func scroll_lines():
	#var x_end = -1000
	#while x_end < 2125:
	#	draw_line(Vector2(x_end + delta,25), Vector2(x_end + delta, 725), GRID_COLOR, grid_width, true)
	#	x_end += grid_spacing
	var y_end = -1000
	while y_end < 1000:
		#draw_line(Vector2(0, y_end + delta), Vector2(1925, y_end + delta), GRID_COLOR, (y_end/grid_width/100), true)
		draw_line(Vector2(0, grid_spacing - (y_end * 30/grid_spacing) + delta), Vector2(1925, grid_spacing - (y_end * 30/grid_spacing) + delta), GRID_COLOR, grid_width, true)
		y_end += grid_spacing - (y_end * 2/grid_spacing)
	if delta < 500:
		delta += 3
	else:
		delta = 0


#func narrow_lines():


func _on_mouse_start_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				drag_start = true
			else:
				drag_start = false
	if event is InputEventMouseMotion:
		if drag_start:
			$start.position = get_local_mouse_position().snapped(Vector2(25,25))
			update()

func _on_mouse_end_gui_input(event):
	print("End it!")
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				drag_start = true
			else:
				drag_start = false
	if event is InputEventMouseMotion:
		if drag_start:
			$end.position = get_local_mouse_position().snapped(Vector2(25,25))
			update()

var dragging_slot_1 = false

func _on_grab_ship(event, type):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				dragging_slot_1 = true
			else:
				dragging_slot_1 = false
	if event is InputEventMouseMotion:
		if dragging_slot_1:
			$ships/fighter/draggable_fighter.rect_global_position = get_global_mouse_position()
			update()

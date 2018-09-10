extends Sprite

const NODE_COLOR = Color(0.8,0.1,0.7,1)
const CONNECTION_COLOR = Color(1.0,0.1,1.0,0.5)
const GRID_COLOR = Color(0.1,0.9,0.5,0.5)
export(float) var connection_width = 2
export(float) var grid_width = 1
export var grid_spacing = 50

var drag_start = false
var drag_end = false
#export(Vector2) var start = Vector2(0,0) setget set_start
#export(Vector2) var end = Vector2(0,0) setget set_end

#func _ready():
	#update()

#func _draw():
#	draw_grid()
	#draw_line($start.position, $end.position, CONNECTION_COLOR, connection_width, true)
	#draw_circle($start.position, 23, NODE_COLOR)
	#draw_circle($end.position, 23, NODE_COLOR)


func draw_grid():
	var x_end = 25
	while x_end < 750:
		draw_line(Vector2(x_end,25), Vector2(x_end, 725), GRID_COLOR, grid_width, true)
		x_end += grid_spacing
	var y_end = 25
	while y_end < 1000:
		draw_line(Vector2(25, y_end), Vector2(725, y_end), GRID_COLOR, grid_width, true)
		y_end += grid_spacing

func _on_mouse_end_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				drag_start = true
			else:
				drag_start = false
	if event is InputEventMouseMotion:
		if drag_start:
			global_position = get_global_mouse_position()
			update()

func toggle_window():
	if visible:
		hide()
	else:
		show()

func _on_close_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				toggle_window()

var can_drag = false
var mouse_in = false
var dragging = false
var mouse_to_center_set = false
var mouse_to_center
var sprite_pos
var mouse_pos

func _process(delta):

	if (mouse_in && Input.is_action_pressed("left_click")): #When clicking
		#First we set mouse_to_center as a static vector
		#for preventing the sprite to move its center to the mouse position
		if not mouse_to_center_set:
			sprite_pos = self.position
			mouse_pos = get_viewport().get_mouse_position()
			mouse_to_center = restaVectores(sprite_pos, mouse_pos)
			mouse_to_center_set = true
		#We set the dragging to true if it's allowed to
		dragging = can_drag

	if (dragging && Input.is_action_pressed("left_click")): #While dragging
		if can_drag:
			mouse_pos = get_viewport().get_mouse_position()

			#Set the position of the sprite to
			#mouse position + static mouse_to_center vector
			var position = sumaVectores(mouse_pos, mouse_to_center)

			set_position(position)
	else: #When we release
		mouse_to_center_set = false #Set this to false so we can set mouse_to_center again
		dragging = false


func _on_Area2D_mouse_entered():
	mouse_in = true
	get_parent()._add_sprite(self) #Add the sprite to the sprite list

func _on_Area2D_mouse_exited():
	mouse_in = false
	get_parent()._remove_sprite(self)  #Remove the sprite from the sprite list

func restaVectores(v1, v2): #vector substraction
	return Vector2(v1.x - v2.x, v1.y - v2.y)

func sumaVectores(v1, v2): #vector sum
	return Vector2(v1.x + v2.x, v1.y + v2.y)
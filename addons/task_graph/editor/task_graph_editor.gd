extends VBoxContainer

onready var taskgraph = get_node("GraphEdit")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func menu_requested(cursor):
	taskgraph.menu_requested(cursor + Vector2(200,200))

func _on_create_task_button_up():
	taskgraph.menu_requested(rect_position)

func _unhandled_key_input(event):
	prints("Unhandled event detected!, event")
	get_tree().set_input_as_handled()

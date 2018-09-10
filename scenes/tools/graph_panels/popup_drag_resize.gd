extends WindowDialog

onready var notebook_panel = get_node("notebook_panel")

# Called when the node enters the scene tree for the first time.
func _ready():
	popup()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_WindowDialog_resized():
	notebook_panel.rect_size = rect_size - Vector2(10,10)
	notebook_panel.rect_global_position = rect_global_position

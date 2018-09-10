extends VBoxContainer

var outputs = []
var source = []
var cell_type = ""

var source_bbcode

onready var source_node = get_node("source")
onready var output_node = get_node("outputs")

var notebook # A scene reference to the cells parent notebook

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#$outputs.hide()

func _on_source_focus_entered():
	if notebook:
		notebook.current_cell_label.set_text("Cell " + name)
		notebook.current_cell_type_label.set_text("Type: " + cell_type)
		#prints("Outputs",typeof(outputs))
		if cell_type == "markdown":
			$outputs.show()
			for line in source:
				$outputs.append_bbcode(line)
			#$outputs.parse_bbcode(source)
		elif not outputs.empty():
			update_outputs()
		else:
			$outputs.hide()

func markdown_to_bbcode(text):
	prints("markdown cell detected, attempting to convert to bbcode")
	$outputs.show()
	source_bbcode = source.replace("### ","=== ")
	source_bbcode = source_bbcode.replace("## ","== ")
	source_bbcode = source_bbcode.replace("# ","= ")
	return source_bbcode

func _on_output_focus_entered():
	if notebook:
		notebook.current_cell_label.set_text("Cell " + name)
		notebook.current_cell_type_label.set_text("Type: " + cell_type)
		$outputs.set_text(outputs)

func set_type(type = ""):
	cell_type = type

func set_source(data = ""):
	$source.set_text("")
	if typeof(data) == TYPE_ARRAY:
		#var output_array = PoolStringArray(data)
		#source = output_array.join("")
		for line in data:
			$source.set_text($source.text + line)
		return true
	else:
		var format_string = "%s source has unhandled data: %s, ."
		var actual_string = format_string % [name, String(source)]
		return false


func _on_outputs_focus_entered():
	pass # Replace with function body.

func _on_source_text_changed():
	pass # Replace with function body.


func update_outputs(new_outputs = outputs):
	outputs = new_outputs
	$outputs.clear()
	match typeof(outputs):
		TYPE_ARRAY:
			if outputs.empty():
				print("hiding " + name)
				$outputs.clear()
				$outputs.hide()
				return
			for output_line in outputs:
				append_outputs(output_line)
		TYPE_STRING:
			append_outputs(outputs)
		_:
			print("%s output has unhandled data: %s" % [name, outputs])

func append_outputs(new_output):
	if typeof(new_output) == TYPE_STRING:
		$outputs.append_bbcode(new_output)
	else:
		$outputs.append_bbcode(String(new_output))
		print("%s output has unhandled data: %s, ." % [name, new_output])

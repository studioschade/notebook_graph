extends Control

var monitoring = false
var time
var histogram = {"10": 0, "25": 0, "50": 0, "75": 0, "100": 0, "150": 0, "200": 0, "max":0}
var monitor_target = "Physics Delta Monitor"

func _ready():
	$title.text = monitor_target

func log_time(time):
	if time < 10:
		histogram["10"] += 1
		get_node("histogram/10").set_text(str(histogram["10"]))
	elif time < 25: 
		histogram["25"] += 1
		get_node("histogram/25").set_text(str(histogram["25"]))
	elif time < 50: 
		histogram["50"] += 1
		get_node("histogram/50").set_text(str(histogram["50"]))
	elif time < 75: 
		histogram["75"] += 1
		get_node("histogram/75").set_text(str(histogram["75"]))
	elif time < 100: 
		histogram["100"] += 1
		get_node("histogram/100").set_text(str(histogram["100"]))
	elif time < 150: 
		histogram["150"] += 1
		get_node("histogram/150").set_text(str(histogram["150"]))
	elif time < 200: 
		histogram["200"] += 1
		get_node("histogram/200").set_text(str(histogram["200"]))
	else: 
		histogram["max"] += 1
		get_node("histogram/max").set_text(str(histogram["max"]))

func _on_clear_stats_pressed():
	for stat in histogram:
		histogram[stat] = 0
		var node_path = "histogram/" + stat
		get_node(node_path).set_text("0")

func _on_monitoring_toggled( pressed ):
	if pressed:
		monitoring = true
	else:
		monitoring = false

func _on_print_stats_pressed():
	print(str(monitor_target))
	print(str(histogram))

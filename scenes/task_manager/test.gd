extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	print("Unless the input of a task relies on the output of another, the strings will print in random orders due to multithreading.")

	$TaskManager.set_input("input1", "STRING #1")
	$TaskManager.set_input("input2", "STRING #2")
	$TaskManager.set_input("input3", "STRING #3")
	$TaskManager.set_input("input4", "Random String #1")
	$TaskManager.set_input("input5", "Random String #2")

	$TaskManager.connect("output_ready", self, "output_ready")
	$TaskManager.connect("finished", self, "finished_all_tasks")

	$TaskManager.start()

func output_ready(output, value):
	print("From Output: " + value)

func finished_all_tasks():
	print("FINSHED!!! This string will always print after all tasks are done")
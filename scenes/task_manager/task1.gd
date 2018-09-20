
var input1
var input2

var output1

func _run():
	output1 = input1 + " : " + input2

static func _inputs():
	return ["input1", "input2"]

static func _outputs():
	return ["output1"]
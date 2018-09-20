extends Reference

const AtomicList = preload("atomic_list.gd")

var _amount
var _sem = Semaphore.new()
var _quit = false
var _tasks = AtomicList.new()

func _init(p_amount = OS.get_processor_count() * 2):
	_amount = p_amount
	var x = 0
	while x < _amount:
		var thread = Thread.new()
		thread.start(self, "_run", thread)
		x += 1

func _run(thread):
	while true:
		_sem.wait()
		if _quit:
			thread.call_deferred("wait_to_finish")
			return
		var task = _tasks.pop_front()
		task[0].callv(task[1], task[2])

func add_task(object, function, args = []):
	#object.callv(function, args) # For calling on the main thread
	_tasks.push_back([object, function, args])
	_sem.post()

func quit():
	_quit = true
	var x = 0
	while x < _amount:
		_sem.post()
		x += 1

func _notification(what):
	if what == NOTIFICATION_PREDELETE and not _quit:
		quit()
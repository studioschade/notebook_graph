extends Reference

var _list = []
var _mutex = Mutex.new()

func push_front(value):
	_mutex.lock()
	_list.push_front(value)
	_mutex.unlock()

func push_back(value):
	_mutex.lock()
	_list.push_back(value)
	_mutex.unlock()

func pop_front():
	_mutex.lock()
	var value = _list.pop_front()
	_mutex.unlock()
	return value

func pop_back():
	_mutex.lock()
	var value = _list.pop_back()
	_mutex.unlock()
	return value

func get(idx):
	pass

func set(idx, value):
	pass
extends Camera2D
# This camera script demonstrates the use of signals, tweens and exported variables.

signal minimap_active(toggled)
export var minimum_zoom = .3
#export var maximum_zoom = 25
export var maximum_zoom = 100


enum {COMBAT, MINIMAP, MEGAMAP}
var zoom_levels = {COMBAT: Vector2(1,1), MINIMAP: Vector2(3,3), MEGAMAP = Vector2(20,20)}
#func set_zoom(zoom):


#export var zoom_rate = 2.2# How fast the zoom accelerates as you go further out
export var zoom_rate = 1.6
export var transition_time = .6
export var minimap_zoom = 5 #Generates a signal to show minimap icons past this zoom level
export var megamap_zoom = 20
var parallax_offset
var toggled = false
var requested_zoom
var background




var process_shake = false

# Shake with decreasing intensity while there's time remaining.
func _process(delta):
	if smoothing_enabled:
		if not $Tween.is_active():
			$Tween.interpolate_property(self, "smoothing_enabled", true, false, 1, Tween.TRANS_LINEAR , Tween.EASE_IN_OUT)
			$Tween.start()
	if process_shake:
		_process_shake(delta)
	#else:
#	if settings.background:
#		settings.background.scroll_offset = position * -1


func input(event):
	if event.is_action_pressed("zoom_in") or Input.is_action_just_pressed("ui_page_up"):
		zoom_in()
	elif event.is_action_pressed("zoom_out") or Input.is_action_just_pressed("ui_page_down"):
		zoom_out()

func _process_shake(delta):
		# Only shake when there's shake time remaining.
	if _timer == 0:
		set_offset(Vector2())
		#set_offset(position * -1)
		process_shake = false
		print("shaking done")
		return
	# Only shake on certain frames.
	_last_shook_timer = _last_shook_timer + delta
	# Be mathematically correct in the face of lag; usually only happens once.
	#while _last_shook_timer >= _period_in_ms:
	if _last_shook_timer >= _period_in_ms:
		_last_shook_timer = _last_shook_timer - _period_in_ms
		# Lerp between [amplitude] and 0.0 intensity based on remaining shake time.
		var intensity = _amplitude * (1 - ((_duration - _timer) / _duration))
		# Noise calculation logic from http://jonny.morrill.me/blog/view/14
		var new_x = rand_range(-1.0, 1.0)
		var x_component = intensity * (_previous_x + (delta * (new_x - _previous_x)))
		var new_y = rand_range(-1.0, 1.0)
		var y_component = intensity * (_previous_y + (delta * (new_y - _previous_y)))
		_previous_x = new_x
		_previous_y = new_y
		# Track how much we've moved the offset, as opposed to other effects.
		var new_offset = Vector2(x_component, y_component)
		set_offset(get_offset() - _last_offset + new_offset)
		#align()
		_last_offset = new_offset
	# Reset the offset when we're done shaking.
	_timer = _timer - delta
	if _timer <= 0:
		_timer = 0
		set_offset(get_offset() - _last_offset)


func zoom_in():
	requested_zoom = get_zoom().x / ( zoom_rate * zoom_rate)
	if requested_zoom > minimum_zoom:
		transition_camera(Vector2(requested_zoom, requested_zoom))

func zoom_out():
	#if settings.background:
#		parallax_offset = settings.background.scroll_offset
	#	settings.background.set_ignore_camera_zoom(true)
	requested_zoom = get_zoom().x * (zoom_rate * zoom_rate)
	if requested_zoom < maximum_zoom:
		transition_camera(Vector2(requested_zoom, requested_zoom))


	#var current_offset = camera.get_offset()
	#var delta = camera_targets[destination].get_global_position() - camera.get_global_position()
	#tween.interpolate_property(get_node("camera"), "offset", current_offset, delta, time, Tween.TRANS_LINEAR , Tween.EASE_IN_OUT)

func move_camera(final_position):
	if not $Tween.is_active():
		$Tween.interpolate_property(self, "global_position", global_position, final_position, transition_time, Tween.TRANS_LINEAR , Tween.EASE_IN_OUT)
		$Tween.start()
		$Tween.set_active(true)
		#var current_offset = camera.get_offset()
		#var delta = camera_targets[destination].get_global_position() - camera.get_global_position()
		#tween.interpolate_property(get_node("camera"), "offset", current_offset, delta, time, Tween.TRANS_LINEAR , Tween.EASE_IN_OUT)
		#if final_zoom.x >= minimap_zoom:
	#		toggle_minimap(true)
#		else:#
		#	toggle_minimap(false)

func _on_Tween_tween_completed(object, key):
	if key == "global_position":
		print("Camera moved")
	$Tween.set_active(false)
#	print(str(zoom))


func transition_camera(final_zoom):
	if not $Tween.is_active():
#		if settings.background:
#			settings.background.set_ignore_camera_zoom(true)
		$Tween.interpolate_property(self, "zoom", get_zoom(), final_zoom, transition_time, Tween.TRANS_LINEAR , Tween.EASE_IN_OUT)
		$Tween.start()
		$Tween.set_active(true)
		if final_zoom.x >= minimap_zoom:
			toggle_minimap(true)
		else:
			toggle_minimap(false)

func toggle_minimap(toggled):
	if toggled:
		#get_tree().call_group_flags(1, "Ships", "minimap_active", true )
		#get_tree().call_group_flags(1, "Minions", "minimap_active", true )
		get_tree().call_group_flags(1, "Minimap", "minimap_active", true )
		#get_tree().call_group_flags(1, "Overlay", "set_zoom", MINIMAP )
	else:
		#get_tree().call_group_flags(1, "Ships", "minimap_active", false )
		#get_tree().call_group_flags(1, "Minions", "minimap_active", false )
		get_tree().call_group_flags(1, "Minimap", "minimap_active", false )
		#get_tree().call_group_flags(1, "Overlay", "set_zoom", COMBAT )
		#func set_zoom(zoom):



var _duration = 0.0
var _period_in_ms = 0.0
var _amplitude = 0.0
var _timer = 0.0
var _last_shook_timer = 0
var _previous_x = 0.0
var _previous_y = 0.0
var _last_offset = Vector2(0, 0)


# Kick off a new screenshake effect.
func shake(duration, frequency, amplitude):
	# Don't interrupt current shake duration
	if not current:
		return
	if(_timer != 0):
		return
	# Initialize variables.
	_duration = duration
	_timer = duration
	_period_in_ms = 1.0 / frequency
	_amplitude = amplitude
	_previous_x = rand_range(-1.0, 1.0)
	_previous_y = rand_range(-1.0, 1.0)
	# Reset previous offset, if any.
	set_offset(get_offset() - _last_offset)
	_last_offset = Vector2(0, 0)
	process_shake = true
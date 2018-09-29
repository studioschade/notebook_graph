extends KinematicBody2D


func _physics_process(delta):
	var move_vector=Vector2(0,0)
	if Input.is_action_pressed("ui_right"):
		move_vector+=Vector2(10,0)
		#apply_impulse(Vector2(0,0),Vector2(200,0))
		#move_and_collide( Vector2(10,0) * (delta * 70), false, true, false)
	if Input.is_action_pressed("ui_left"):
		#apply_impulse(Vector2(0,0),Vector2(-200,0))
		move_vector+=Vector2(-10,0)
		#move_and_collide( Vector2(-10,0) * (delta * 70), true, true, false)
	if Input.is_action_pressed("ui_up"):
		#apply_impulse(Vector2(0,0),Vector2(0,-200))
		move_vector+=Vector2(0,-10)
		#move_and_collide( Vector2(0,-10) * (delta * 70), true, true, false)
	if Input.is_action_pressed("ui_down"):
		move_vector+=Vector2(0,10)
		#apply_impulse(Vector2(0,0),Vector2(0,200))
		#for controller in Input.get_connected_joypads():
		#	prints("name:", Input.get_joy_name(controller),"guid:", Input.get_joy_axis(0,0), delta * 100)
		#move_and_collide( Vector2(0,10)* (delta * 70), true, true, false)
	move_and_collide( move_vector * (delta * 70), true, true, false)
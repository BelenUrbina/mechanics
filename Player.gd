extends KinematicBody2D

export (int) var speed = 700
export (int) var friction = 0.1
export (int) var dashspeed = 1000
export (int) var gravity = 2000
export (int) var jump_height = -850
export (int) var dashdistance = 3
var motion:Vector2 = Vector2.ZERO


#Dash
var dashdirection = 0
var candash:bool = true

#Coyote timer
onready var coyote_timer = $CoyoteTimer

#Double jump
var jump_max:int = 2
var jump_count:int = 0

func _physics_process(delta):
	motion.y += gravity * delta
	
	motion.x = lerp(motion.x, 0, friction)
	if is_on_floor():
		candash = true
	if Input.is_action_just_pressed("dash") and candash:
		motion = dashdirection.normalized() * dashspeed * dashdistance
		candash = false
	if Input.is_action_pressed("right"):
		motion.x = +speed
		dashdirection = Vector2.RIGHT
	if Input.is_action_pressed("left"):
		motion.x = -speed
		dashdirection = Vector2.LEFT
	if Input.is_action_just_pressed("jump") and jump_count<jump_max and (is_on_floor() or !coyote_timer.is_stopped() or jump_count > 0):
		jump_count += 1
		motion.y = jump_height
	var was_on_floor = is_on_floor()
	motion = move_and_slide(motion, Vector2.UP)
	#Reset jumpcount
	if is_on_floor() and jump_count != 0:
		jump_count = 0
	if !is_on_floor() and was_on_floor:
		coyote_timer.start()
		



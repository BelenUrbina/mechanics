extends KinematicBody2D

export (int) var speed = 700
export (int) var friction = 0.1
export (int) var dashspeed = 1000

export (int) var gravity = 2000
export (int) var jump_height = -850
export (int) var dashdistance = 3
var motion:Vector2 = Vector2.ZERO

# Dash
var dashdirection:Vector2 = Vector2.ZERO
var candash:bool = true

# Coyote timer
onready var coyote_timer:Timer = $CoyoteTimer

#Double jump
var jump_max:int = 2
var jump_count:int = 0

# Wall jump
var jump_from_wall:bool = false


func _physics_process(delta):
	# Wall jump
	if is_on_wall():
		print("wall jump")
		if !jump_from_wall:
			motion.y = 0
		jump_count = 0
	else:
		jump_from_wall = false
		gravity = 2000
		
	motion.y += gravity * delta
	motion.x = lerp(motion.x, 0, friction)
	
	if is_on_floor():
		candash = true
	if Input.is_action_just_pressed("dash") and candash:
		motion = dashdirection.normalized() * dashspeed * dashdistance
		candash = false
	if Input.is_action_pressed("right") and candash:
		motion.x = +speed
		dashdirection = Vector2.RIGHT
	if Input.is_action_pressed("left") and candash:
		motion.x = -speed 
		dashdirection = Vector2.LEFT
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			motion.y = jump_height
			jump_count += 1
			print("jump from floor")
			jump_from_wall = false
		elif is_on_wall():
			print("jump from wall")
			motion.y = jump_height
			jump_from_wall = true 
		else:
			# Double Jump
			if jump_count > 0 and jump_count < jump_max:
				motion.y = jump_height
				jump_count += 1
				print("double jump")
			# Coyote time
			if !coyote_timer.is_stopped() and jump_count == 0:
				motion.y = jump_height
				jump_count += 1
				print("coyote jump")

	var was_on_floor = is_on_floor()
	motion = move_and_slide(motion, Vector2.UP)
	# Reset jumpcount
	if is_on_floor() and jump_count != 0:
		jump_count = 0
	if !is_on_floor() and was_on_floor:
		coyote_timer.start()


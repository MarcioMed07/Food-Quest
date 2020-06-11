extends KinematicBody2D

const GRAVITY = 9.8
const TERMINAL_FALL_SPEED = 200
const WALL_UP_FORCE = 7
const WALL_TERMINAL_FALL_SPEED = 50
const ACCELERATION = 5
const DECELERATION = 0.4
const SPRINT_MULTIPLIER = 1.8
const MAX_SPEED = 100
const AIR_ACCELERATION = 2
const AIR_DECELERATION = 0.015
const JUMP_FORCE = 200
const WALL_JUMP_SPEED = 90
const AUTO_GRAPPLING = true
export var SLEEP_THRESH = 2
var velocity = Vector2.ZERO
var sleep_count = 0
var sprinting  = 1

func _process(delta):
	velocity.y = min(velocity.y + GRAVITY, TERMINAL_FALL_SPEED)
	if is_on_floor():
		move_on_floor(delta)
	else:
		move_on_air(delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	pass
	
func move_on_floor(delta):
	if Input.is_action_just_pressed("jump"):
		velocity.y = -JUMP_FORCE
	if Input.is_action_pressed("sprint"):
		sprinting = SPRINT_MULTIPLIER
	else:
		sprinting = 1
	if Input.is_action_pressed("left"):
		velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED * sprinting)
		$Sprite.play("Run")
		$Sprite.flip_h = true
		$Sprite.speed_scale = sprinting
		sleep_count = 0
	elif Input.is_action_pressed("right"):
		velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED * sprinting)
		$Sprite.play("Run")
		$Sprite.flip_h = false
		$Sprite.speed_scale = sprinting
		sleep_count = 0
	else:
		velocity.x = lerp(velocity.x, 0, DECELERATION)
		$Sprite.play("Idle")
		if sleep_count > SLEEP_THRESH:
			$Sprite.play("Sleep")
		sleep_count += delta
	pass

func move_on_air(_delta):
	sleep_count = 0
	var grap_wall = AUTO_GRAPPLING
	if Input.is_action_pressed("left"):
		velocity.x = max(velocity.x - AIR_ACCELERATION, -MAX_SPEED * sprinting)
		grap_wall = false
		$Sprite.flip_h = true
	elif Input.is_action_pressed("right"):
		velocity.x = min(velocity.x + AIR_ACCELERATION, MAX_SPEED * sprinting)
		grap_wall = false
		$Sprite.flip_h = false
	else:
		velocity.x = lerp(velocity.x, 0, AIR_DECELERATION)
	if is_on_wall():
		print('p',velocity.x)
		$Sprite.play("Slide")
		var collision_dir = 0
		for i in range(get_slide_count()):
			collision_dir -= get_slide_collision(i).normal.x
		$Sprite.flip_h = collision_dir > 0
		if velocity.y > 0:
			velocity.y = max(velocity.y - WALL_UP_FORCE, WALL_TERMINAL_FALL_SPEED)
		
		if grap_wall:
			velocity.x = AIR_ACCELERATION * collision_dir
			
		if Input.is_action_just_pressed("jump"):
			velocity.y = -JUMP_FORCE
			velocity.x = -collision_dir * WALL_JUMP_SPEED
	else:
		if velocity.y < 0:
			$Sprite.play("Jump")
		else:
			$Sprite.play("Fall")
	pass


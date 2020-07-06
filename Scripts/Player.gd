extends KinematicBody2D

const GRAVITY = 9.8
const TERMINAL_FALL_SPEED = 200
const WALL_UP_FORCE = 7
const WALL_TERMINAL_FALL_SPEED = 50
const ACCELERATION = 5
const DECELERATION = 0.4
const SPRINT_MULTIPLIER = 1.8
const MAX_SPEED = 100
const AIR_ACCELERATION = 3
const AIR_DECELERATION = 0.025
const JUMP_TIMER_MAX = 0.2
const JUMP_FORCE = 200
const ENEMY_JUMP_FORCE = 200
const WALL_JUMP_SPEED = 110
const AUTO_GRAPPLING = true
const IFRAME_TRESH = 2
const COYOTE_TIMER_MAX = 0.1
export var SLEEP_THRESH = 2
var velocity = Vector2.ZERO
var sleep_count = 0
var iframe_count = IFRAME_TRESH
var sprinting  = 1
var jump_timer = 0
var coyote_timer = 0

func _process(delta):
	update_ui()
	velocity.y = min(velocity.y + GRAVITY, TERMINAL_FALL_SPEED)
	jump_timer = max(0, jump_timer-delta)
	coyote_timer = max(0, coyote_timer-delta)
	if $Sprite.animation != "Damage":
		if Input.is_action_just_pressed("jump"):
			jump_timer = JUMP_TIMER_MAX
		if Input.is_action_just_released("jump") && velocity.y < 0:
			velocity.y *= 0.3
		if is_on_floor():
			coyote_timer = COYOTE_TIMER_MAX
			move_on_floor(delta)
		else:
			move_on_air(delta)
		if coyote_timer > 0 && jump_timer > 0:
			coyote_timer = 0
			jump_timer = 0
			velocity.y = -JUMP_FORCE
		if Input.is_action_pressed("ui_down"):
			$Camera2D.offset.y = min($Camera2D.offset.y + delta*60, 48)
		else:
			$Camera2D.offset.y = max($Camera2D.offset.y - delta*120, -16)
		print($Camera2D.offset.y)
			
		velocity = move_and_slide(velocity, Vector2.UP)
	
		if iframe_count <= IFRAME_TRESH:
			iframe_count += delta
			if fmod(iframe_count,0.20) <= delta:
				visible = !visible
		else:
			visible = true
	pass

func update_ui():
	if $HUD:
		$HUD/Control/LifeLabel.text = "Health: " + str(PlayerVariables.health)
		$HUD/Control/FpsLabel.text = "FPS: " + str(Engine.get_frames_per_second())
	pass
func move_on_floor(delta):
	for area in $Hitbox.get_overlapping_areas():
		if area.get_collision_layer_bit(3):
			velocity.x *= 0.9
	if Input.is_action_pressed("sprint"):
		sprinting = SPRINT_MULTIPLIER
	else:
		sprinting = 1
	if Input.is_action_pressed("left"):
		velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED * sprinting)
		$Sprite.play("Run")
		$Sprite.flip_h = true
		sleep_count = 0
	elif Input.is_action_pressed("right"):
		velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED * sprinting)
		$Sprite.play("Run")
		$Sprite.flip_h = false
		sleep_count = 0
	else:
		velocity.x = lerp(velocity.x, 0, DECELERATION)
		$Sprite.play("Idle")
		if sleep_count >= SLEEP_THRESH:
			$Sprite.play("Sleep")
		sleep_count = min(sleep_count + delta, SLEEP_THRESH)
	$Sprite.speed_scale = sprinting
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

func _on_Hitbox_area_entered(area):
	if area.get_collision_layer_bit(2):
		if global_position.y - area.global_position.y <= -4:
			velocity.y = -ENEMY_JUMP_FORCE
		elif iframe_count >= IFRAME_TRESH:
			iframe_count = 0
			$Sprite.play("Damage")
			PlayerVariables.health -= 1
			if PlayerVariables.health <= 0:
				var camera_node = get_node("Camera2D")
				camera_node.get_parent().remove_child(camera_node)
				area.add_child(camera_node)
				queue_free()
	if area.get_collision_layer_bit(3):
		print(global_position.y - area.global_position.y)
		if global_position.y - area.global_position.y <= 6 && iframe_count >= IFRAME_TRESH:
			iframe_count = 0
			$Sprite.play("Damage")
			PlayerVariables.health -= 1
			if PlayerVariables.health <= 0:
				var camera_node = get_node("Camera2D")
				camera_node.get_parent().remove_child(camera_node)
				area.add_child(camera_node)
				queue_free()
	pass # Replace with function body.


func _on_Sprite_animation_finished():
	if $Sprite.animation == "Damage":
		$Sprite.play("Idle")
	pass # Replace with function body.

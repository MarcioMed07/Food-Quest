extends KinematicBody2D

const GRAVITY = 9.8
const TERMINAL_FALL_SPEED = 200
const MAX_SPEED = 50
var velocity = Vector2.ZERO
var dir = 1
var dead = false

func _ready():
	pass 
	
func _process(delta):
	velocity.y += GRAVITY
	$Sprite.flip_h = dir > 0
	if dead:
		return
	if is_on_floor():
		if velocity.x == 0:
			dir *= -1
		velocity.x = MAX_SPEED * dir
	velocity = move_and_slide(velocity, Vector2.UP)

func die():
	dead = true
	$Sprite.play("death")
	$Hitbox.collision_layer

func _on_Hitbox_area_entered(area):
	if area.collision_layer == 2:
		if area.global_position.y - global_position.y <= -4:
			die()
	pass # Replace with function body.

func _on_Sprite_animation_finished():
	if $Sprite.animation == "death":
		queue_free()
	pass # Replace with function body.

extends CharacterBody2D
class_name Player

# FSM

enum {MOVE, IDLE, ATTACK}

# Export our movement data resource
@export() var moveData = Resource

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_timer = $attack_timer
@onready var hitbox = $Area2D/player_hitbox

# Set inital state
var state = IDLE

# Variables for full scope
var current_direction = "Down"
var is_attacking = false

func ready():
	moveData = moveData as PlayerMovementData
	hitbox.disabled = true

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x = Input.get_axis("ui_left", "ui_right")
	var direction_y = Input.get_axis("ui_up", "ui_down")

	movement(direction_x, direction_y)
	attack()

	move_and_slide()

func movement(inputx, inputy):
	if inputx:
		velocity.x = inputx * moveData.MAX_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, moveData.MAX_SPEED)
		
	if inputy:
		velocity.y = inputy * moveData.MAX_SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, moveData.MAX_SPEED)
	
	animate_movement(inputx, inputy)
	state = IDLE
	

func animate_movement(inputx, inputy):
	
	if not is_attacking:
		if inputx < 0:
			animated_sprite.play("moveLeft")
			current_direction = "Left"
				
		if inputx > 0:
			animated_sprite.play("moveRight")
			current_direction = "Right"
				
		if inputy < 0:
			animated_sprite.play("moveUp")
			current_direction = "Up"
				
		if inputy > 0:
			animated_sprite.play("moveDown")
			current_direction = "Down"
		else:
			animated_sprite.play("move"+current_direction)

func attack():
	var direction = current_direction
	if Input.is_action_just_pressed("ui_select"):

		is_attacking = true
		if direction == "Left":
			animated_sprite.play("attackLeft")
			attack_timer.start()
		
		if direction == "Right":
			animated_sprite.play("attackRight")
			attack_timer.start()
			
		if direction == "Up":
			animated_sprite.play("attackUp")
			attack_timer.start()
			
		if direction == "Down":
			animated_sprite.play("attackDown")
			attack_timer.start()


func _on_attack_timer_timeout():
	attack_timer.stop()
	is_attacking = false
	hitbox.disabled = true

func _on_animated_sprite_2d_animation_changed():
	if is_attacking:
		if animated_sprite.animation == "attackLeft":
			hitbox.disabled = false
			hitbox.position.x = -15
			hitbox.position.y = -2
		if animated_sprite.animation == "attackRight":
			hitbox.disabled = false
			hitbox.position.x = 11
			hitbox.position.y = -2
		if animated_sprite.animation == "attackUp":
			hitbox.disabled = false
			hitbox.position.x = -0.875
			hitbox.position.y = -15
		if animated_sprite.animation == "attackDown":
			hitbox.disabled = false
			hitbox.position.x = -1
			hitbox.position.y = 8


func _on_area_2d_area_entered(area:Area2D):
	if area.is_in_group("hit"):
		print("ouch")

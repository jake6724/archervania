class_name Player
extends CharacterBody2D

# Child references
@onready var bow: Sprite2D = $Bow
@onready var ap: AnimationPlayer = $AnimationPlayer

var health: float = 5
var speed: float = 500
var draw_complete: bool = false

func _process(_delta):
	# Aim bow
	bow.look_at(get_global_mouse_position())

	# Move 
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = speed * direction
	else:
		velocity.x = 0

	# Apply gravity
	velocity.y += 9.81

	move_and_slide()

func _input(_event):
	# Shoot
	if Input.is_action_just_pressed("left_click"):
		ap.play("draw")
	
	if Input.is_action_pressed("left_click"):
		if draw_complete:
			ap.play("hold")

	if Input.is_action_just_released("left_click"):
		ap.play("release")
		ap.queue("RESET")
	
	# Jump
	if Input.is_action_just_pressed("jump"):
		velocity.y = -850

func set_draw_complete(value: bool) -> void:
	draw_complete = value
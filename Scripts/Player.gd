class_name Player
extends CharacterBody2D

# Child references
@onready var bow: Sprite2D = $Bow
@onready var ap: AnimationPlayer = $AnimationPlayer

@onready var arrow_scene: PackedScene = preload("res://Scenes/Arrow.tscn")

var health: float = 5
var speed: float = 500
var jump: float = -750
var draw_complete: bool = false
var max_draw_strength: float = 2000

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
		draw_complete = false
		ap.play("draw")

	if Input.is_action_just_released("left_click"):
		shoot_arrow()
		ap.play("release")
		ap.queue("RESET")
	
	# Jump
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump

func set_draw_complete(value: bool) -> void:
	draw_complete = value
	ap.play("hold")

func shoot_arrow():
	var d = get_local_mouse_position().normalized()
	var new_arrow = arrow_scene.instantiate()
	new_arrow.position += d * 100
	add_child(new_arrow)

	var draw_strength: float
	if draw_complete:
		draw_strength = max_draw_strength
	else:
		draw_strength = ap.current_animation_position * max_draw_strength

	new_arrow.fly(draw_strength, d)

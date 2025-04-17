class_name Player
extends CharacterBody2D

# Child references
@onready var bow: Sprite2D = $Bow
@onready var ap: AnimationPlayer = $AnimationPlayer

@onready var arrow_scene: PackedScene = preload("res://Scenes/Arrow.tscn")

var health: float = 5
var speed: float = 500
var jump: float = -750
var jump_count: int = 0
var draw_complete: bool = false
var base_draw_strength: float = 1500
var max_draw_strength: float = 1500
var draw_strength: float = 0
var draw_strength_threshold: float = 10
var trajectory_line: Line2D

func _ready():
	trajectory_line = Line2D.new()
	add_child(trajectory_line)

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
	# velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * _delta

	calc_draw_strength()

	move_and_slide()
	queue_redraw()

func _draw():
	if draw_strength > draw_strength_threshold:
		draw_trajectory()

func _input(event):
	# Shoot
	if event.is_action_pressed("left_click"):
		draw_complete = false
		ap.play("draw")

	if event.is_action_released("left_click"):
		shoot_arrow()
		draw_strength = 0
		ap.play("release")
		ap.queue("RESET")
		queue_redraw()
	
	# Jump
	if event.is_action_pressed("jump"):

		if is_on_floor():
			jump_count = 0

		if jump_count == 0:
			jump_count += 1
			velocity.y = jump

func calc_draw_strength() -> void:
	if ap.current_animation:
		if ap.current_animation == "draw":
			var p = ap.current_animation_position / ap.get_animation(ap.current_animation).length
			if draw_complete:
				draw_strength = base_draw_strength + max_draw_strength
			else:
				draw_strength = base_draw_strength + (p * max_draw_strength)
	else:
		draw_strength = 0

func set_draw_complete(value: bool) -> void:
	draw_complete = value
	ap.play("hold")

func shoot_arrow():
	var d = get_local_mouse_position().normalized()
	var new_arrow = arrow_scene.instantiate()
	new_arrow.position += d * 100
	add_child(new_arrow)
	new_arrow.fly(draw_strength, d)

func get_forward_direction() -> Vector2:
	return global_position.direction_to(get_global_mouse_position())
	
func draw_trajectory():
	var arrow_velocity: Vector2 = draw_strength * get_forward_direction()

	var line_start: Vector2 = global_position + get_forward_direction() * 100
	var line_end: Vector2
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
	var drag: float = ProjectSettings.get_setting("physics/2d/default_linear_damp") * 2
	var timestep:float = 0.02
	var colors: Array = [Color.WHITE]

	for i:int in 70:
		arrow_velocity.y += gravity * timestep
		line_end = line_start + (arrow_velocity * timestep)
		arrow_velocity = arrow_velocity * clampf(1.0 - drag * timestep, 0, 1)
		draw_line_global(line_start, line_end, colors[0])
		line_start = line_end


func draw_line_global(point_a: Vector2, point_b: Vector2, color: Color, width: int = 5) -> void:
	var a_local_offset:= point_a - global_position
	var b_local_offset := point_b - global_position
	draw_line(a_local_offset, b_local_offset, color, width) 

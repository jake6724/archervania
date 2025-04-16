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
var draw_strength: float
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

	var p = ap.current_animation_position / ap.get_animation(ap.current_animation).length 

	if draw_complete:
		draw_strength = max_draw_strength
	else:
		draw_strength = p * max_draw_strength

	calc_trajectory()
	new_arrow.fly(draw_strength, d)

func calc_trajectory():
	var angle = global_position.angle_to_point(get_global_mouse_position())
	print("angle: ", -rad_to_deg(angle))

	


# func calc_trajectory():
# 	trajectory_line.clear_points()
# 	trajectory_line.add_point(to_local(global_position))
# 	for i in range(10):
# 		var d = (get_global_mouse_position() - global_position).normalized()
# 		var angle = atan2(d.y, d.x)
# 		var x = global_position.x + ((draw_strength * ap.current_animation_position / ap.get_animation(ap.current_animation).length) 
# 		* cos(angle) * i)

# 		var y = global_position.y + (((draw_strength * ap.current_animation_position / ap.get_animation(ap.current_animation).length) 
# 		* sin(angle) * i) - .5 * 9.81 * i * i)

# 		var new_point: Vector2 = Vector2(x, y)
# 		print("New point: ", new_point)
# 		trajectory_line.add_point(new_point)
# 		print("Updated TLPs: ", trajectory_line.points)
# 	print(trajectory_line.points)

# func calc_trajectory():
# 	print("Calc T")

# 	for i in range(10):

# 		var d = (get_global_mouse_position() - global_position).normalized()
# 		var angle = atan2(d.y, d.x)
# 		var x = global_position.x + ((draw_strength * ap.current_animation_position / ap.get_animation(ap.current_animation).length) 
# 		* cos(angle) * i)

# 		var y = global_position.y + ((draw_strength * ap.current_animation_position / ap.get_animation(ap.current_animation).length) 
# 		* sin(angle) * i)

		
# 		var line: Line2D = Line2D.new()
# 		# add_child(line)
# 		trajectory_line.points = PackedVector2Array([to_local(global_position), Vector2(x,y)])

# 		print("Line gp: ", line.global_position)
# 		print("Player gp: ", global_position)
# 		print("Line points: ", line.points)

class_name Arrow
extends RigidBody2D

var velocity: Vector2

func _ready():
	gravity_scale = 2

func fly(strength: float, direction: Vector2):
	rotation = direction.angle()
	var impulse: Vector2 = direction * strength
	apply_impulse(impulse)

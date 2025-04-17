class_name Enemy
extends Area2D

@onready var main = get_tree().root.get_node("Main")
@onready var player = main.get_node("Player")
var speed: float = 200

func _ready():
	body_entered.connect(on_body_entered)

func _process(delta):
	position += position.direction_to(player.global_position) * speed * delta

func on_body_entered(invader) -> void:
	if invader is Arrow:
		invader.queue_free()
		queue_free()

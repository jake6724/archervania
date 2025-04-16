extends Camera2D

@export var player: Player

func _process(_delta):
	position = player.position

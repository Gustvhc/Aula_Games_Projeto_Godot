extends Node3D

@export var player: Player
@export var reset_pos: Marker3D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Reset"):
		player.velocity = Vector3.ZERO
		player.rotation = reset_pos.rotation
		player.position = reset_pos.position

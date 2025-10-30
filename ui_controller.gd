extends MarginContainer

@export var player: Player
@export var speed: Label
@export var angle: Label
@export var camera: Camera3D

func _process(delta: float) -> void:
	#speed.text = str(snapped(abs(player.velocity.x)+abs(player.velocity.z),0.01))
	speed.text = str(round(abs(player.velocity.x)+abs(player.velocity.z)))
	angle.text = str(camera.rotation)

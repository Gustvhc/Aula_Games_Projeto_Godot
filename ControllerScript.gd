extends Node3D

@export var player: Player
@export var reset_pos: Marker3D
@export var temp: Marker3D

func _process(delta: float) -> void:
	pass
	if Input.is_action_just_pressed("Reset"):
		player.velocity = Vector3.ZERO
		player.rotation = reset_pos.rotation
		player.position = reset_pos.position

# Fundo da Fase 1
func _on_area_3d_body_entered(body: Node3D) -> void:
	player.velocity = Vector3.ZERO
	player.rotation = reset_pos.rotation
	player.position = reset_pos.position

# Final da Fase 1
func _on_area_3d_2_body_entered(body: Node3D) -> void:
	temp = $InicioFase2
	player.velocity = Vector3.ZERO
	player.rotation = temp.rotation
	player.position = temp.position


func _on_area_3d_body_entered_fase2(body: Node3D) -> void:
	temp = $InicioFase2
	player.velocity = Vector3.ZERO
	player.rotation = temp.rotation
	player.position = temp.position


func _on_area_3d_2_body_entered_final_fase_2(body: Node3D) -> void:
	temp = $InicioFase3
	player.velocity = Vector3.ZERO
	player.rotation = temp.rotation
	player.position = temp.position


func _on_area_3d_3_body_entered_fase_3_lava(body: Node3D) -> void:
	temp = $InicioFase3
	player.velocity = Vector3.ZERO
	player.rotation = temp.rotation
	player.position = temp.position

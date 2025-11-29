extends Marker3D

class_name ProjectileSpawner


#@export var projectile: Node
@export var character: Node

@export var spawner_downtime:float = 0.0;

var projectile = load("res://Weapon/Projectiles/Bullet.tscn")

var instance

var is_downtime = false

#func _ready():
	#projectile = projectile.load()

#https://www.youtube.com/watch?v=OdWa6r1yI4U
#https://www.youtube.com/watch?v=6bbPHsB9TtI
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Shoot") and not is_downtime:
		is_downtime = true
		instance = projectile.instantiate()
		instance.initial_pos = self.global_position
		instance.position = self.global_position
		instance.transform.basis = self.global_transform.basis
		#get_parent().add_child(instance)
		character.get_parent().add_child(instance)
		await get_tree().create_timer(1.0).timeout

func _on_timer_timeout() -> void:
	is_downtime = false

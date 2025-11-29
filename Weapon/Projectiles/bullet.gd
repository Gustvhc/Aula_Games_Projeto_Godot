extends Projectile

class_name Bullet

@onready var collider = $RayCast3D

var initial_pos: Vector3

func _process(delta: float) -> void:
	self.position+=transform.basis * Vector3(speed,0,0) * delta
	if collider.is_colliding():
		self.queue_free()
	if(initial_pos.distance_to(self.position) > distance):
		self.queue_free()

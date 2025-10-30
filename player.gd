extends CharacterBody3D

class_name Player
@export_category("Movement")

@export_group("Jump","jump_")
@export var jump_enabled: bool = true
@export var jump_speed: float = 0
@export var jump_height: float = 0
@export var jump_strenght: float = 0
@export var jump_wall_distance:float = 1
@export_range(0,1) var jump_friction_on_air: float = 1
@export_range(1,50) var jump_gravity: float = 1
#@export_enum("A","B","C") var jump_type = "A"

@export_group("Sprint","sprint_")
@export var sprint_enabled: bool = true
@export var sprint_speed:float = 0

@export_group("Controls","input_")
@export var input_forward: String = "Forward"
@export var input_left: String = "Left"
@export var input_back: String = "Back"
@export var input_right: String = "Right"
@export var input_jump: String = "Jump"
@export var input_crouch: String = "Crouch"
@export var input_sprint: String = "Sprint"

@export_group("Velocity","vel_")
@export var vel_base_speed: float = 0
@export var vel_acceleration: float = 0
@export_range(0,1) var vel_slow: float = 0


@export_category("External")
@export var body: MeshInstance3D
@export_range(0.001,0.01,0.0001) var mouse_sensitivity: float = 0.003

var mouse_locked: bool = false
@onready var move_speed: float = vel_base_speed

@onready var ray_left = $RayLeft
@onready var ray_right = $RayRight
var wall_jump_vec: Vector3
var current_wall: Node3D
var last_wall: Node3D

func _ready() -> void:
	ray_left.target_position.z = -jump_wall_distance
	ray_right.target_position.z = jump_wall_distance

#https://www.youtube.com/watch?v=AW3rT-7J8ag
#https://www.youtube.com/watch?v=ke5KpqcoiIU
func _physics_process(delta: float) -> void:
	get_move_input(delta)
	
	if not is_on_floor():
		velocity+= get_gravity() * delta * jump_gravity
	
	if jump_enabled:
		if Input.is_action_just_pressed(input_jump):
			jump()
			
	if sprint_enabled and Input.is_action_pressed(input_sprint) and is_on_floor():
		move_speed = vel_base_speed + sprint_speed
	else:
		move_speed = lerp(move_speed,vel_base_speed,0.01)
			
	
	
	
	move_and_slide()

#Mouse Controls
func _unhandled_input(event: InputEvent) -> void:
	if Globals.debug_mode:
		if not mouse_locked:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				lock_mouse()
		else:
			if event is InputEventMouseMotion:
				if snapped(abs($Camera3D.rotation.x),0.1) > 1.5:
					$Camera3D.rotation.x = lerp($Camera3D.rotation.x,sign($Camera3D.rotation.x) * 1.5,0.05)
				else:
					$Camera3D.rotation.x -= event.relative.y * mouse_sensitivity
				
				self.rotation.y -= event.relative.x * mouse_sensitivity
			if Input.is_action_pressed("Escape"):
				unlock_mouse()
	

func jump():
	if is_on_floor():
		velocity.y = jump_speed
		last_wall = null
	else:
		if Input.is_action_just_pressed("Jump"):
			check_close_wall()
			if current_wall!=last_wall:
				velocity += (wall_jump_vec) * jump_strenght
				last_wall = current_wall

#Para testes e menu de pause
func lock_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_locked = true

func unlock_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_locked = false

#Based from Godot Docs
func check_close_wall():
	var speed_and_height = Vector3(0,jump_height*(((abs(velocity.x)+abs(velocity.z))/2)*0.21),0)
	
	if ray_left.is_colliding() and ray_right.is_colliding():
		return
	
	if ray_left.is_colliding():
		wall_jump_vec = ray_left.get_collision_normal() + speed_and_height
		current_wall = ray_left.get_collider()
		
	if ray_right.is_colliding():
		wall_jump_vec = ray_right.get_collision_normal() + speed_and_height
		current_wall = ray_right.get_collider()
		
	if not ray_left.is_colliding() and not ray_right.is_colliding():
		wall_jump_vec = Vector3.ZERO
	

#https://www.youtube.com/watch?v=AW3rT-7J8ag
func get_move_input(delta: float):
	var vy = velocity.y
	velocity.y = 0

	var xz = Input.get_vector(input_back, input_forward, input_left, input_right)
	
	if not is_on_floor():
		xz *= jump_friction_on_air
		
	var direction = Vector3(xz.x,0,xz.y).rotated(Vector3.UP,self.rotation.y)
	
	
	if xz != Vector2.ZERO:
		velocity = lerp(velocity, direction * move_speed, vel_acceleration * delta)
	else:
		velocity = velocity*vel_slow
		
		
	velocity.y = vy
	

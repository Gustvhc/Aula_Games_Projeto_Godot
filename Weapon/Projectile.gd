extends CharacterBody3D

class_name Projectile

@export_category("Base")
@export var speed: float = 0
@export var size: float = 1
@export var falloff: float = 0.1
@export var distance: float = 20
@export var damage: float = 10
@export var explosive: bool = false

@export_group("Explosive","exp_")
@export var exp_radius: float = 0
@export var exp_damage: float = 10

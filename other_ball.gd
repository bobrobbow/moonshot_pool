extends "res://ball.gd"

var moving = false

func _ready():
	cueball = false


func _physics_process(delta):
	print(applied_force)
	if linear_velocity.x > 1.0 and linear_velocity.y > 1.0:
		if !moving:
			print(linear_velocity)
			print("moving now")
		moving = true
	elif linear_velocity.x < 1.0 and linear_velocity.y < 1.0:
		if moving:
			print("not moving now")
		moving = false

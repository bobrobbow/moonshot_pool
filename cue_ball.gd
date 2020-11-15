extends "res://ball.gd"

func _ready():
	cueball = true

func _on_ball_body_entered(body):
	print("body entered")
	if body.has_node("gravity_field"):
		print("not cueball")
		body.get_node("gravity_field").gravity_point = false

extends Node2D


var cueball
onready var ball_scene = preload("res://ball.tscn")
onready var cueball_scene = preload("res://cue_ball.tscn")
var num_balls = 10
var other_balls = []
var reset_cueball = false
onready var max_x = $playable_se.position.x
onready	var min_x = $playable_nw.position.x
onready	var max_y = $playable_se.position.y
onready	var min_y = $playable_nw.position.y


# Called when the node enters the scene tree for the first time.
func _ready():
	cueball = cueball_scene.instance()
	cueball.position = _get_spawnable_point_in_playable_area()
	add_child(cueball)
	cueball = get_node("ball")
	var count = 1
	for _x in range(0, num_balls):
		print("spawning new ball")
		var spawn_pos = _get_spawnable_point_in_playable_area()
		if spawn_pos == Vector2(-1,-1):
			print("error in spawning!")
			continue
		var newball = ball_scene.instance()
		newball.position = spawn_pos
		add_child(newball)
		other_balls.push_back(newball)
		count += 1

func _get_spawnable_point_in_playable_area():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var stop = false
	var count = 0
	var max_x = $playable_se.position.x
	var min_x = $playable_nw.position.x
	var max_y = $playable_se.position.y
	var min_y = $playable_nw.position.y
	while !stop:
		print("searching for spawn point")
		print(count)
		if count > 100:
			return Vector2(-1,-1)
		var ranx = rng.randi() % ( int(max_x) - int(min_x) ) + int(min_x)
		var rany = rng.randi() % ( int(max_y) - int(min_y) ) + int(min_y)
		var ranvec = Vector2(ranx, rany)
		for item in other_balls:
			var item_pos = item.position
			var distance_x = ranvec.x - item_pos.x
			var distance_y = ranvec.y - item_pos.y
			if (distance_x < 30 and distance_x > -30) or \
			(distance_y < 30 and distance_y > -30):
				count += 1
				print("clashing spawn point found, trying again")
				continue
		print("found good spawn point at " + str(ranvec))
		return ranvec
		count += 1
	return Vector2(-1,-1)
	
func _physics_process(delta):
	if cueball.position.x < min_x - 100 or cueball.position.x > max_x + 100 \
	or cueball.position.y < min_y - 100 or cueball.position.y > max_y + 100:
		reset_cueball = true
	if reset_cueball:
		cueball.set_linear_velocity(Vector2(0,0))
		cueball.set_angular_velocity(0)
		cueball.position = _get_spawnable_point_in_playable_area()
		reset_cueball = false

func _ball_in_pocket(area):
	if "ball_centre" in area:
		if area.get_parent() == cueball:
			reset_cueball = true
		else:
			other_balls.erase(area.get_parent())
			area.get_parent().queue_free()

func _on_nwpocket_area_entered(area):
	_ball_in_pocket(area)

func _on_sepocket_area_entered(area):
	_ball_in_pocket(area)


func _on_swpocket_area_entered(area):
	_ball_in_pocket(area)


func _on_wpocket_area_entered(area):
	_ball_in_pocket(area)


func _on_epocket_area_entered(area):
	_ball_in_pocket(area)


func _on_nepocket_area_entered(area):
	_ball_in_pocket(area)

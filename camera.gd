extends Camera2D

var zoom_step = 1.1
var min_zoom = 0.6
var max_zoom = 2.3
var pan_speed = 800

func _ready():
	pass


func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		position.x = position.x - pan_speed * delta
	if Input.is_action_pressed("ui_right"):
		position.x = position.x + pan_speed * delta
	if Input.is_action_pressed("ui_down"):
		position.y = position.y + pan_speed * delta
	if Input.is_action_pressed("ui_up"):
		position.y = position.y - pan_speed * delta
	_snap_to_limits()

func _input(event):
	if event is InputEventMouse:
		if event.is_pressed() and not event.is_echo():
			var mouse_position = event.position
			if event.button_index == BUTTON_WHEEL_DOWN:
				if zoom < Vector2( max_zoom, max_zoom ):
					zoom_at_point(zoom_step,mouse_position)
					_snap_zoom_limits()
			elif event.button_index == BUTTON_WHEEL_UP:
				if zoom > Vector2( min_zoom, min_zoom ):
					zoom_at_point(1/zoom_step,mouse_position)
					_snap_zoom_limits()

func zoom_at_point(zoom_change, point):
	var c0 = global_position # camera position
	var v0 = get_viewport().size # vieport size
	var c1 # next camera position
	var z0 = zoom # current zoom value
	var z1 = z0 * zoom_change # next zoom value

	c1 = c0 + (-0.5*v0 + point)*(z0 - z1)
	zoom = z1
	global_position = c1

# force position to be inside limit_rect
func _snap_to_limits():
	return
	#position.x = clamp(position.x, limit_rect.position.x, limit_rect.end.x)
	#position.y = clamp(position.y, limit_rect.position.y, limit_rect.end.y)

func _snap_zoom_limits():
	zoom.x = clamp(zoom.x, min_zoom, max_zoom)
	zoom.y = clamp(zoom.y, min_zoom, max_zoom)

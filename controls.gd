extends Node2D

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT \
			and event.pressed:
				self._on_click(event)

func _on_click(_event):
	# get direction of mouse click relative to centre of ball
	print("click!")
	var mousepos = get_global_mouse_position()
	var dir = get_parent().cueball.get_global_position() - mousepos
	get_parent().cueball.apply_impulse(Vector2(), dir * 10 )

extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$jugar.grab_focus()

func _input(event):
	if event is InputEventMouseButton:
		print("Clic detectado")

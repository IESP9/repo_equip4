extends CharacterBody3D
var ORIGINAL_SPEED
var SPEED = 3.0
var sprint_drain_amount = 0.5
var sprint_refresh_amount = 0.3
var SPRINT_SPEED = 7.0
const JUMP_VELOCITY = 3.5
var sprint_slider

func _ready() -> void:
	ORIGINAL_SPEED = SPEED
	sprint_slider = get_node("/root/" + get_tree().current_scene.name + "/UI/sprint_slider")
	
	# Asegurar que el jugador esté en el grupo correcto
	if not is_in_group("jugador"):
		add_to_group("jugador")

func _process(delta) -> void:
	if SPEED == SPRINT_SPEED:
		sprint_slider.value = sprint_slider.value - sprint_drain_amount * delta
		if sprint_slider.value == sprint_slider.min_value:
			SPEED = ORIGINAL_SPEED
	if SPEED != SPRINT_SPEED:
		if sprint_slider.value < sprint_slider.max_value:
			sprint_slider.value = sprint_slider.value + sprint_refresh_amount * delta
		if sprint_slider.value == sprint_slider.max_value:
			sprint_slider.visible = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("backward", "forward", "left", "right")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		if Input.is_action_just_pressed("sprint"):
			sprint_slider.visible = true
			SPEED = SPRINT_SPEED
		if Input.is_action_just_released("sprint"):
			SPEED = ORIGINAL_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _1ready():
	$CanvasLayer.hide()  # Oculta el menú al inicio

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Presionar ESC
		$CanvasLayer.visible = not $CanvasLayer.visible  # Alterna visibilidad
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if $CanvasLayer.visible else Input.MOUSE_MODE_CAPTURED)

# Función para cuando el jugador muera
func morir():
	print("El jugador ha muerto")  # Puedes cambiar esto por animaciones o sonidos
	get_tree().change_scene_to_file("res://game_over.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

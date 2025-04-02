extends CharacterBody3D

@export var speed: float = 3.0
@export var acceleration: float = 5.0
@export var detection_range: float = 10.0
@export var gravity: float = 9.8

var player: Node3D = null
var velocity_vector: Vector3 = Vector3.ZERO

@onready var raycast: RayCast3D = $RayCast3D

func _ready():
	# Buscar al jugador en la escena
	var players = get_tree().get_nodes_in_group("jugador")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta):
	if player:
		var direction_to_player = (player.global_transform.origin - global_transform.origin).normalized()
		var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
	   
		# Configurar el RayCast3D para detectar al jugador
		raycast.target_position = to_local(player.global_transform.origin)
		raycast.force_raycast_update()
	   
		if distance_to_player <= detection_range and is_player_visible():
			move_towards_player(direction_to_player, delta)

	apply_gravity(delta)
	move_and_slide()

func move_towards_player(direction: Vector3, delta: float):
	velocity_vector = velocity_vector.lerp(direction * speed, acceleration * delta)
	velocity = velocity_vector

func apply_gravity(delta: float):
	if not is_on_floor():
		velocity_vector.y -= gravity * delta

func is_player_visible() -> bool:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		return collider != null and collider.is_in_group("jugador")
	return false

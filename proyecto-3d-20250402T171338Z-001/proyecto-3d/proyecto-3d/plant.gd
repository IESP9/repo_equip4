extends Node3D


# Velocidad de movimiento del enemigo
@export var velocidad: float = 4.0

# Distancia máxima para seguir al jugador
@export var distancia_maxima: float = 14.0

# Referencia al jugador (asignada desde el editor o buscada en el código)
var jugador: Node3D = null

func _ready():
	# Buscar al jugador en la escena (asume que el jugador tiene un grupo "jugador")
	var jugadores = get_tree().get_nodes_in_group("jugador")
	if jugadores.size() > 0:
		jugador = jugadores[0]
	else:
		print("Error: No se encontró ningún nodo en el grupo 'jugador'.")

func _process(delta):
	if jugador:
		# Calcular la distancia al jugador
		var distancia = global_transform.origin.distance_to(jugador.global_transform.origin)
		
		# Si el jugador está dentro de la distancia máxima, seguirlo
		if distancia < distancia_maxima:
			# Hacer que el enemigo mire hacia el jugador
			look_at(jugador.global_transform.origin, Vector3.UP)
			
			# Calcular la dirección hacia el jugador
			var direccion = (jugador.global_transform.origin - global_transform.origin).normalized()
			
			# Mover al enemigo en la dirección del jugador
			velocity = direccion * velocidad
			move_and_slide()

func _physics_process(delta):
	# Revisar colisiones para detectar al jugador
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var obj = collision.get_collider()
		if obj and obj.is_in_group("jugador"):  # Si colisiona con el jugador
			obj.morir()  # Llama a la función morir() del jugador
